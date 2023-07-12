import logging

from aiogram import Bot, Dispatcher
from aiogram.types import BotCommand, BotCommandScopeAllGroupChats
from aiogram.utils.i18n import get_i18n, gettext

logger = logging.getLogger()


async def on_startup(bot: Bot, _: Dispatcher) -> None:
    i18n = get_i18n()
    logger.info("Setting up bot commands")

    for lang in i18n.available_locales:
        await bot.set_my_commands(
            [
                BotCommand(
                    command="start",
                    description=gettext("start_command_description"),
                ),
            ],
            scope=BotCommandScopeAllGroupChats(),
            language_code=lang,
        )
