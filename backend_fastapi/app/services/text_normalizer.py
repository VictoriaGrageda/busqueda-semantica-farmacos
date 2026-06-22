import re
import unicodedata


def normalize_text(text: str) -> str:
    normalized = text.lower()
    normalized = unicodedata.normalize("NFD", normalized)
    normalized = "".join(
        character for character in normalized if unicodedata.category(character) != "Mn"
    )
    normalized = re.sub(r"[^a-z0-9ñ\s]", " ", normalized)
    normalized = re.sub(r"\s+", " ", normalized).strip()
    return normalized
