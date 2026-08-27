from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes.agent import router as agent_router
from app.api.routes.knowledge_base import router as knowledge_base_router
from app.api.routes.search import router as search_router
from app.core.config import (
    API_DESCRIPTION,
    API_TITLE,
    API_VERSION,
    CORS_ALLOWED_ORIGINS,
)
from app.database.session import SessionLocal, init_database
from app.services.database_seed import seed_knowledge_base


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_database()
    with SessionLocal() as db:
        seed_knowledge_base(db)
    yield


def create_app() -> FastAPI:
    app = FastAPI(
        title=API_TITLE,
        description=API_DESCRIPTION,
        version=API_VERSION,
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=CORS_ALLOWED_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(search_router)
    app.include_router(agent_router)
    app.include_router(knowledge_base_router)
    return app


app = create_app()
