from pathlib import Path

from pypdf import PdfReader


def extract_pdf_pages(pdf_path: Path) -> list[dict]:
    reader = PdfReader(str(pdf_path))
    pages = []

    for index, page in enumerate(reader.pages, start=1):
        pages.append(
            {
                "page": index,
                "text": page.extract_text() or "",
            }
        )

    return pages
