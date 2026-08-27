from app.repositories.document_repository import DocumentRepository
from app.services.embedding_service import generate_embedding


class DocumentSearchService:
    def __init__(self, repository: DocumentRepository) -> None:
        self._repository = repository

    def search(self, query: str, limit: int = 3) -> list[dict]:
        query_embedding = generate_embedding(query)
        chunks = self._repository.search_chunks_by_embedding(query_embedding, limit=limit)

        return [
            {
                "documento": chunk["documento"],
                "pagina_inicio": chunk["page_start"],
                "pagina_fin": chunk["page_end"],
                "puntaje": chunk["puntaje"],
                "fragmento": self._shorten(chunk["text"]),
            }
            for chunk in chunks
            if chunk["puntaje"] >= 0.12
        ]

    def _shorten(self, text: str, max_length: int = 420) -> str:
        compact = " ".join(text.split())
        if len(compact) <= max_length:
            return compact
        return f"{compact[:max_length].rstrip()}..."
