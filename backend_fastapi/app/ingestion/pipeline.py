import json
from pathlib import Path

from app.core.config import (
    PDF_SOURCES_PATH,
    PROCESSED_CHUNKS_PATH,
    PROCESSED_ENTITIES_PATH,
    PROCESSED_PATH,
    PROCESSED_TEXT_PATH,
)
from app.ingestion.chunker import chunk_pages
from app.ingestion.entity_detector import detect_chunk_entities
from app.ingestion.pdf_extractor import extract_pdf_pages
from app.ingestion.text_cleaner import clean_page_text, clean_text


def run_pdf_processing(source_dir: Path = PDF_SOURCES_PATH) -> dict:
    _ensure_processed_dirs()

    manifest = {
        "documentos": [],
        "total_documentos": 0,
        "total_chunks": 0,
    }

    for pdf_path in sorted(source_dir.rglob("*.pdf")):
        processed_document = _process_pdf(pdf_path)
        manifest["documentos"].append(processed_document)
        manifest["total_chunks"] += processed_document["chunks"]

    manifest["total_documentos"] = len(manifest["documentos"])
    (PROCESSED_PATH / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    return manifest


def _process_pdf(pdf_path: Path) -> dict:
    pages = clean_page_text(extract_pdf_pages(pdf_path))
    full_text = clean_text("\n\n".join(page["text"] for page in pages))
    chunks = chunk_pages(pages)

    slug = _slugify(pdf_path.stem)
    text_output = PROCESSED_TEXT_PATH / f"{slug}.txt"
    chunks_output = PROCESSED_CHUNKS_PATH / f"{slug}.json"
    entities_output = PROCESSED_ENTITIES_PATH / f"{slug}.json"

    text_output.write_text(full_text, encoding="utf-8")

    chunk_records = [
        {
            **chunk,
            "source_pdf": str(pdf_path),
            "processed_text": str(text_output),
        }
        for chunk in chunks
    ]
    chunks_output.write_text(
        json.dumps(chunk_records, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    entity_records = [
        {
            "chunk_index": chunk["chunk_index"],
            "page_start": chunk["page_start"],
            "page_end": chunk["page_end"],
            **detect_chunk_entities(chunk["text"]),
        }
        for chunk in chunks
    ]
    entities_output.write_text(
        json.dumps(entity_records, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    return {
        "titulo": pdf_path.stem,
        "ruta_pdf": str(pdf_path),
        "texto_procesado": str(text_output),
        "chunks_json": str(chunks_output),
        "entidades_json": str(entities_output),
        "paginas": len(pages),
        "chunks": len(chunks),
    }


def _ensure_processed_dirs() -> None:
    PROCESSED_TEXT_PATH.mkdir(parents=True, exist_ok=True)
    PROCESSED_CHUNKS_PATH.mkdir(parents=True, exist_ok=True)
    PROCESSED_ENTITIES_PATH.mkdir(parents=True, exist_ok=True)


def _slugify(value: str) -> str:
    allowed = []
    for character in value.lower():
        if character.isalnum():
            allowed.append(character)
        elif character in {" ", "-", "_"}:
            allowed.append("_")

    slug = "".join(allowed)
    while "__" in slug:
        slug = slug.replace("__", "_")
    return slug.strip("_")
