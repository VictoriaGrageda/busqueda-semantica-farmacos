import re


def clean_text(text: str) -> str:
    cleaned = text.replace("\x00", " ")
    cleaned = re.sub(r"-\s*\n\s*", "", cleaned)
    cleaned = re.sub(r"\s+\n", "\n", cleaned)
    cleaned = re.sub(r"\n{3,}", "\n\n", cleaned)
    cleaned = re.sub(r"[ \t]{2,}", " ", cleaned)
    return cleaned.strip()


def clean_page_text(pages: list[dict]) -> list[dict]:
    return [
        {
            "page": page["page"],
            "text": clean_text(page["text"]),
        }
        for page in pages
        if clean_text(page["text"])
    ]
