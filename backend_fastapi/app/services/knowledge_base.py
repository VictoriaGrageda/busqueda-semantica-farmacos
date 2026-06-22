import json
from pathlib import Path
from typing import Any

from app.core.config import KNOWLEDGE_BASE_PATH


def load_medicines(path: Path = KNOWLEDGE_BASE_PATH) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)
