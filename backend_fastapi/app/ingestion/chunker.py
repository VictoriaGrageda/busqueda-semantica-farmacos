from app.core.config import CHUNK_OVERLAP, CHUNK_SIZE


def chunk_pages(
    pages: list[dict],
    chunk_size: int = CHUNK_SIZE,
    overlap: int = CHUNK_OVERLAP,
) -> list[dict]:
    chunks = []
    current_text = ""
    page_start = 1
    page_end = 1

    for page in pages:
        page_number = page["page"]
        text = page["text"]

        if not current_text:
            page_start = page_number

        if len(current_text) + len(text) + 1 <= chunk_size:
            current_text = f"{current_text}\n{text}".strip()
            page_end = page_number
            continue

        if current_text:
            chunks.append(
                {
                    "chunk_index": len(chunks),
                    "page_start": page_start,
                    "page_end": page_end,
                    "text": current_text,
                }
            )

        overlap_text = current_text[-overlap:] if overlap > 0 else ""
        current_text = f"{overlap_text}\n{text}".strip()
        page_start = max(1, page_number - 1)
        page_end = page_number

    if current_text:
        chunks.append(
            {
                "chunk_index": len(chunks),
                "page_start": page_start,
                "page_end": page_end,
                "text": current_text,
            }
        )

    return chunks
