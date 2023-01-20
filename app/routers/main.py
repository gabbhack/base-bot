from aiogram import Router

from app.routers.base.base import router as start_router

router = Router()
router.include_router(start_router)
