from pathlib import Path
import os

PROJECT_ROOT = Path(__file__).resolve().parents[3]
KNOWLEDGE_BASE_PATH = PROJECT_ROOT / "base_conocimiento" / "data" / "medicamentos.json"

API_TITLE = "Agente de busqueda semantico farmacologico"
API_DESCRIPTION = "API para busqueda de informacion farmacologica."
API_VERSION = "1.0.0"

CORS_ALLOWED_ORIGINS = ["*"]

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://farmacos_user:farmacos_password@localhost:5432/farmacos_db",
)

EMBEDDING_DIMENSIONS = 384
