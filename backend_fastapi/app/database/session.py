from collections.abc import Generator

from sqlalchemy import create_engine, text
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import DATABASE_URL


class Base(DeclarativeBase):
    pass


engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_database() -> None:
    from app.models.knowledge_chunk import KnowledgeChunk  # noqa: F401
    from app.models.knowledge_document import KnowledgeDocument  # noqa: F401
    from app.models.knowledge_source import KnowledgeSource  # noqa: F401
    from app.models.medicine import Medicine  # noqa: F401
    from app.models.semantic_relation import SemanticRelation  # noqa: F401

    with engine.begin() as connection:
        connection.execute(text("CREATE EXTENSION IF NOT EXISTS vector"))

    Base.metadata.create_all(bind=engine)

    with engine.begin() as connection:
        connection.execute(
            text(
                "CREATE INDEX IF NOT EXISTS ix_medicines_embedding_hnsw "
                "ON medicines USING hnsw (embedding vector_cosine_ops)"
            )
        )
        connection.execute(
            text(
                "CREATE INDEX IF NOT EXISTS ix_knowledge_chunks_embedding_hnsw "
                "ON knowledge_chunks USING hnsw (embedding vector_cosine_ops)"
            )
        )
