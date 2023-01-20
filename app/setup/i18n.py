import logging

from aiogram import Dispatcher
from aiogram.utils.i18n import I18n, SimpleI18nMiddleware

from app.settings import SETTINGS

logger = logging.getLogger()


def get_i18n() -> I18n:
    return I18n(
        path=SETTINGS.I18N_PATH,
        default_locale=SETTINGS.I18N_DEFAULT_LOCALE,
        domain=SETTINGS.I18N_DOMAIN,
    )


def setup_i18n(dispatcher: Dispatcher) -> None:
    logger.info("Setting up i18n")
    i18n = get_i18n()
    middleware = SimpleI18nMiddleware(i18n=i18n)
    dispatcher.update.outer_middleware.register(middleware)
