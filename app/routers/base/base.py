from aiogram import Router
from aiogram.filters import CommandStart
from aiogram.types import Message
from aiogram.utils.i18n import gettext as _

router = Router()


@router.message(CommandStart())
async def cmd_start(message: Message) -> None:
    await message.answer(_("Hello!"))
