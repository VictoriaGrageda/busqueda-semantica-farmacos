from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[3]


def _load_project_env() -> None:
    env_path = PROJECT_ROOT / ".env"
    if not env_path.exists():
        return

    for raw_line in env_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


_load_project_env()

KNOWLEDGE_SOURCES_PATH = PROJECT_ROOT / "base_conocimiento" / "data" / "fuentes.json"
SEMANTIC_RELATIONS_PATH = (
    PROJECT_ROOT / "base_conocimiento" / "data" / "relaciones_farmacologicas.json"
)
PDF_SOURCES_PATH = PROJECT_ROOT / "base_conocimiento" / "sources" / "farmacologicas"
PROCESSED_PATH = PROJECT_ROOT / "base_conocimiento" / "processed"
PROCESSED_TEXT_PATH = PROCESSED_PATH / "text"
PROCESSED_CHUNKS_PATH = PROCESSED_PATH / "chunks"
PROCESSED_ENTITIES_PATH = PROCESSED_PATH / "entities"

API_TITLE = "Agente de busqueda semantico farmacologico"
API_DESCRIPTION = "API para busqueda de informacion farmacologica."
API_VERSION = "1.0.0"

CORS_ALLOWED_ORIGINS = ["*"]

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://farmacos_user:farmacos_password@localhost:5432/farmacos_db",
)

EMBEDDING_DIMENSIONS = 384
CHUNK_SIZE = 1800
CHUNK_OVERLAP = 250
