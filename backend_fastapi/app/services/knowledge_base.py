import json
from pathlib import Path
from typing import Any

from app.core.config import KNOWLEDGE_BASE_PATH
from app.core.config import KNOWLEDGE_SOURCES_PATH, SEMANTIC_RELATIONS_PATH


def load_medicines(path: Path = KNOWLEDGE_BASE_PATH) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)


def load_sources(path: Path = KNOWLEDGE_SOURCES_PATH) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)


def load_semantic_relations(
    path: Path = SEMANTIC_RELATIONS_PATH,
) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)
