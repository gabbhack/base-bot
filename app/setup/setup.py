from aiogram import Bot, Dispatcher

from app.setup import commands, webhook
from app.setup.i18n import setup_i18n


async def on_startup(bot: Bot, dispatcher: Dispatcher) -> None:
    setup_i18n(dispatcher)
    await commands.on_startup(bot, dispatcher)
    await webhook.on_startup(bot, dispatcher)
