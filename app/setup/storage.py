from aiogram.fsm.storage.base import BaseEventIsolation, BaseStorage
from aiogram.fsm.storage.memory import MemoryStorage, SimpleEventIsolation


def get_storage() -> BaseStorage:
    return MemoryStorage()


def get_events_isolation() -> BaseEventIsolation:
    return SimpleEventIsolation()
