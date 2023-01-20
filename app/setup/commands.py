import logging

from aiogram import Bot, Dispatcher
from aiogram.types import BotCommand, BotCommandScopeAllGroupChats

logger = logging.getLogger()


async def on_startup(bot: Bot, _: Dispatcher) -> None:
    logger.info("Setting up bot commands")
    await bot.set_my_commands(
        [
            BotCommand(command="start", description="Cтapт"),
        ],
        scope=BotCommandScopeAllGroupChats(),
    )
