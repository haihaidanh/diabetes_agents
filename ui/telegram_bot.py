"""Bot Telegram cho hệ đa agent tư vấn tiểu đường.

Chạy:  TELEGRAM_TOKEN=... python main.py telegram      (tuỳ chọn: ALLOWED_IDS=123,456 để giới hạn người dùng)
- Tin nhắn chữ  -> run_case(...) (Supervisor/Intake/Risk/Knowledge/Advisor/Critic), nhớ hồ sơ theo từng chat.
- Gửi ảnh       -> CNN (perception.vision) -> thông báo sàng lọc có luật cứng + tư vấn lấy từ KG qua run_case.
- /reset xoá hồ sơ đã nhớ của chat; ảnh được xoá ngay sau khi xử lý.
"""
import asyncio
import logging
import os
import re
import tempfile

from telegram import Update
from telegram.constants import ChatAction
from telegram.ext import Application, CommandHandler, ContextTypes, MessageHandler, filters

log = logging.getLogger("diabetes-bot")
LIMIT = 4000                                  # Telegram tối đa 4096 ký tự / tin
PATIENTS: dict[int, dict] = {}                # chat_id -> hồ sơ đã trích ở các lượt trước
LLM_LOCK = asyncio.Lock()                     # một GPU: xử lý lần lượt từng yêu cầu

HELLO = ("Xin chào! Mình là trợ lý thông tin về bệnh tiểu đường.\n\n"
         "• Nhắn thông tin của bạn (tuổi, giới, chiều cao/cân nặng hoặc BMI, HbA1c, đường huyết...) để ước lượng nguy cơ.\n"
         "• Hỏi bất kỳ câu hỏi về tiểu đường, mình trả lời kèm nguồn.\n"
         "• Gửi ảnh bàn chân hoặc ảnh đáy mắt để sàng lọc dấu hiệu biến chứng.\n\n"
         "/reset – xoá thông tin bạn đã nhập.\n"
         "⚠️ Chỉ mang tính tham khảo, không thay thế bác sĩ.")

PHOTO_TOPIC = {   # nhãn CNN -> câu hỏi gửi vào pipeline để lấy tư vấn có nguồn từ KG
    "loet_ban_chan": "Vết loét ở bàn chân của người bị đái tháo đường nguy hiểm thế nào và cần làm gì?",
    "vong_mac_tieu_duong": "Bệnh võng mạc đái tháo đường là gì và khi nào cần đi khám mắt?",
}
PHOTO_MSG = {
    "loet_ban_chan": "Ảnh có dấu hiệu giống tổn thương loét bàn chân",
    "ban_chan_binh_thuong": "Ảnh chưa thấy dấu hiệu loét rõ ràng ở da bàn chân",
    "vong_mac_tieu_duong": "Ảnh đáy mắt có dấu hiệu giống bệnh võng mạc do tiểu đường",
    "binh_thuong_hoac_khac": "Ảnh không có dấu hiệu rõ ràng của biến chứng tiểu đường (hoặc không phải loại ảnh mình nhận biết)",
}


def plain(text: str) -> str:
    """Markdown của câu trả lời -> văn bản thường cho Telegram."""
    text = re.sub(r"\[([^\]]+)\]\((https?://[^)]+)\)", r"\1: \2", text)
    return text.replace("**", "").replace("__", "").strip()


def chunks(text: str, limit: int = LIMIT) -> list:
    """Cắt theo đoạn/dòng để không vượt giới hạn của Telegram."""
    out, cur = [], ""
    for line in text.split("\n"):
        while len(line) > limit:
            if cur:
                out.append(cur); cur = ""
            out.append(line[:limit]); line = line[limit:]
        if len(cur) + len(line) + 1 > limit:
            out.append(cur); cur = line
        else:
            cur = f"{cur}\n{line}" if cur else line
    if cur:
        out.append(cur)
    return [c for c in out if c.strip()]


def allowed(update: Update) -> bool:
    ids = {int(i) for i in os.getenv("ALLOWED_IDS", "").replace(" ", "").split(",") if i}
    return not ids or (update.effective_user and update.effective_user.id in ids)


async def reply(update: Update, text: str):
    for part in chunks(plain(text)):
        await update.message.reply_text(part, disable_web_page_preview=True)


def ask_pipeline(question: str, patient: dict) -> dict:
    from agents.graph import run_case          # import trễ: nạp mô hình, KG, embedding khi cần
    return run_case(question, {}, patient)


async def cmd_start(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    if allowed(update):
        await update.message.reply_text(HELLO)


async def cmd_reset(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    if allowed(update):
        PATIENTS.pop(update.effective_chat.id, None)
        await update.message.reply_text("Đã xoá thông tin bạn đã nhập trong cuộc trò chuyện này.")


async def on_text(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    if not allowed(update):
        return
    cid, q = update.effective_chat.id, update.message.text or ""
    await ctx.bot.send_chat_action(cid, ChatAction.TYPING)
    try:
        async with LLM_LOCK:
            st = await asyncio.to_thread(ask_pipeline, q, PATIENTS.get(cid, {}))
        if st.get("patient"):
            PATIENTS[cid] = st["patient"]
        await reply(update, st.get("answer") or "Mình chưa có câu trả lời phù hợp.")
    except Exception as e:                      # không để bot chết vì một yêu cầu lỗi
        log.exception("lỗi xử lý tin nhắn")
        await update.message.reply_text("Xin lỗi, hệ thống đang gặp lỗi. Bạn thử lại sau nhé.")


def assess_photo(path: str) -> dict:
    from perception import vision
    return vision.assess(path)


async def on_photo(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    if not allowed(update):
        return
    cid = update.effective_chat.id
    await ctx.bot.send_chat_action(cid, ChatAction.TYPING)
    f = tempfile.NamedTemporaryFile(suffix=".jpg", delete=False)
    f.close()
    try:
        photo = update.message.photo[-1] if update.message.photo else None
        tgfile = await ctx.bot.get_file(photo.file_id if photo else update.message.document.file_id)
        await tgfile.download_to_drive(f.name)
        async with LLM_LOCK:
            r = await asyncio.to_thread(assess_photo, f.name)
            lab, conf = r["label"], r["confidence"]
            if r["uncertain"]:
                await reply(update, f"Mình chưa đủ cơ sở để kết luận từ ảnh này (độ tin cậy {conf:.0%}). "
                                    "Bạn thử chụp rõ hơn, đủ sáng, hoặc nếu lo lắng về vết thương/mắt thì hãy đi khám bác sĩ.\n\n"
                                    "⚠️ Chỉ là sàng lọc từ ảnh, không phải chẩn đoán.")
                return
            head = f"{PHOTO_MSG.get(lab, lab)} (độ tin cậy {conf:.0%}). Đây chỉ là sàng lọc từ ảnh, không phải chẩn đoán; cần bác sĩ xác nhận."
            if lab in PHOTO_TOPIC:
                head += " Bạn nên đi khám sớm."
            await reply(update, head)
            if lab in PHOTO_TOPIC:
                st = await asyncio.to_thread(ask_pipeline, PHOTO_TOPIC[lab], PATIENTS.get(cid, {}))
                await reply(update, st.get("answer") or "")
    except Exception:
        log.exception("lỗi xử lý ảnh")
        await update.message.reply_text("Xin lỗi, mình không xử lý được ảnh này. Bạn thử gửi lại ảnh khác nhé.")
    finally:
        try:
            os.unlink(f.name)                   # không lưu ảnh của người dùng
        except OSError:
            pass


def build_app(token: str) -> Application:
    app = Application.builder().token(token).concurrent_updates(True).build()
    app.add_handler(CommandHandler(["start", "help"], cmd_start))
    app.add_handler(CommandHandler("reset", cmd_reset))
    app.add_handler(MessageHandler(filters.PHOTO | filters.Document.IMAGE, on_photo))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, on_text))
    return app


def main():
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(name)s %(levelname)s %(message)s")
    token = os.getenv("TELEGRAM_TOKEN")
    if not token:
        raise SystemExit("Thiếu biến môi trường TELEGRAM_TOKEN (lấy từ @BotFather)")
    build_app(token).run_polling(drop_pending_updates=True)


if __name__ == "__main__":
    main()