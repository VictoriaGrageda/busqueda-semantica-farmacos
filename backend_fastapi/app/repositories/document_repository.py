from sqlalchemy.orm import Session

from app.models.knowledge_chunk import KnowledgeChunk
from app.models.knowledge_document import KnowledgeDocument


class DocumentRepository:
    def __init__(self, db: Session) -> None:
        self._db = db

    def count_documents(self) -> int:
        return self._db.query(KnowledgeDocument).count()

    def upsert_document(self, document_data: dict) -> KnowledgeDocument:
        document = (
            self._db.query(KnowledgeDocument)
            .filter(KnowledgeDocument.ruta_archivo == document_data["ruta_archivo"])
            .one_or_none()
        )

        if document is None:
            document = KnowledgeDocument(**document_data)
            self._db.add(document)
            self._db.flush()
            return document

        for key, value in document_data.items():
            setattr(document, key, value)

        self._db.query(KnowledgeChunk).filter(
            KnowledgeChunk.document_id == document.id
        ).delete()
        self._db.flush()
        return document

    def add_chunk(self, chunk_data: dict) -> None:
        self._db.add(KnowledgeChunk(**chunk_data))

    def search_chunks_by_embedding(
        self,
        embedding: list[float],
        limit: int = 5,
    ) -> list[dict]:
        distance = KnowledgeChunk.embedding.cosine_distance(embedding)
        rows = (
            self._db.query(KnowledgeChunk, KnowledgeDocument.titulo, (1 - distance).label("score"))
            .join(
                KnowledgeDocument,
                KnowledgeDocument.id == KnowledgeChunk.document_id,
            )
            .order_by(distance)
            .limit(limit)
            .all()
        )
        return [
            chunk.to_dict(document_title=title, score=round(float(score), 4))
            for chunk, title, score in rows
        ]

    def list_documents(self) -> list[dict]:
        documents = (
            self._db.query(KnowledgeDocument)
            .order_by(KnowledgeDocument.titulo.asc())
            .all()
        )
        return [document.to_dict() for document in documents]
