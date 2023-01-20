import asyncio
import logging
import sys

import sentry_sdk
from aiogram import Bot, Dispatcher
from aiohttp.web import run_app
from sentry_sdk.integrations.aiohttp import AioHttpIntegration

from app.routers.main import router as main_router
from app.settings import SETTINGS
from app.setup import setup
from app.setup.storage import get_events_isolation, get_storage

logger = logging.getLogger()
logger.setLevel(logging.INFO)
log_handler = logging.StreamHandler(stream=sys.stdout)
logger.addHandler(log_handler)


def main() -> None:
    if SETTINGS.SENTRY_URL:
        sentry_sdk.init(
            dsn=SETTINGS.SENTRY_URL,
            integrations=[
                AioHttpIntegration(),
            ],
            traces_sample_rate=1.0,
        )
    bot = Bot(SETTINGS.BOT_TOKEN.get_secret_value(), parse_mode="HTML")
    dp = Dispatcher(
        storage=get_storage(),
        events_isolation=get_events_isolation(),
    )
    dp.startup.register(setup.on_startup)
    dp.include_router(main_router)

    if dp.get("webhook_app"):
        logger.info("Starting webhook")
        run_app(dp["webhook_app"], port=SETTINGS.PORT)
    else:
        logger.info("Starting polling")
        asyncio.run(
            dp.start_polling(
                bot,
                allowed_updates=dp.resolve_used_update_types(),
            ),
        )


if __name__ == "__main__":
    logger.warning("Starting bot")
    main()
    logger.warning("Bot stopped")
