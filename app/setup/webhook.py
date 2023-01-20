import logging

from aiogram import Bot, Dispatcher
from aiogram.webhook.aiohttp_server import (
    SimpleRequestHandler,
    ip_filter_middleware,
    setup_application,
)
from aiogram.webhook.security import IPFilter
from aiohttp.web_app import Application

from app.settings import SETTINGS

logger = logging.getLogger()


def setup_app(bot: Bot, dispatcher: Dispatcher) -> Application:
    app = Application()
    request_handler = SimpleRequestHandler(dispatcher=dispatcher, bot=bot)
    app.middlewares.append(ip_filter_middleware(IPFilter.default()))

    request_handler.register(app, path="/webhook")
    setup_application(app, dispatcher, bot=bot)

    app["bot"] = bot

    return app


async def on_startup(bot: Bot, dispatcher: Dispatcher) -> None:
    if SETTINGS.WEBHOOK_URL and SETTINGS.PORT:
        logger.info("Setting up webhook", extra={"url": SETTINGS.WEBHOOK_URL})
        await bot.set_webhook(
            url=SETTINGS.WEBHOOK_URL,
            allowed_updates=dispatcher.resolve_used_update_types(),
        )
        app = setup_app(bot, dispatcher)
        dispatcher["webhook_app"] = app
