import json
from pathlib import Path

from sqlalchemy.orm import Session

from app.core.config import PROCESSED_CHUNKS_PATH
from app.ingestion.medicine_extractor import extract_medicines_from_processed_texts
from app.repositories.document_repository import DocumentRepository
from app.repositories.medicine_repository import MedicineRepository
from app.services.embedding_service import generate_embedding


def load_processed_chunks_to_database(
    db: Session,
    chunks_dir: Path = PROCESSED_CHUNKS_PATH,
) -> dict:
    repository = DocumentRepository(db)
    summary = {
        "documentos": 0,
        "chunks": 0,
    }

    for chunks_file in sorted(chunks_dir.glob("*.json")):
        chunks = json.loads(chunks_file.read_text(encoding="utf-8"))
        if not chunks:
            continue

        first_chunk = chunks[0]
        source_pdf = Path(first_chunk["source_pdf"])
        processed_text = Path(first_chunk["processed_text"])

        document = repository.upsert_document(
            {
                "titulo": source_pdf.stem,
                "tipo_fuente": "manual_farmacologico",
                "ruta_archivo": str(source_pdf),
                "ruta_texto_procesado": str(processed_text),
                "paginas": max(chunk["page_end"] for chunk in chunks),
                "estado": "procesado",
            }
        )

        for chunk in chunks:
            repository.add_chunk(
                {
                    "document_id": document.id,
                    "chunk_index": chunk["chunk_index"],
                    "page_start": chunk["page_start"],
                    "page_end": chunk["page_end"],
                    "text": chunk["text"],
                    "embedding": generate_embedding(chunk["text"]),
                }
            )

        summary["documentos"] += 1
        summary["chunks"] += len(chunks)

    db.commit()
    return summary


def load_extracted_medicines_to_database(db: Session) -> dict:
    repository = MedicineRepository(db)
    medicines = extract_medicines_from_processed_texts()
    deleted = repository.delete_all()

    for medicine in medicines:
        repository.add(
            medicine_data=medicine,
            document=medicine["documento_busqueda"],
            embedding=generate_embedding(medicine["documento_busqueda"]),
        )

    db.commit()
    return {
        "eliminados": deleted,
        "insertados": len(medicines),
    }
