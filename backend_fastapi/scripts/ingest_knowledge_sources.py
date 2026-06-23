from pathlib import Path
import sys

BACKEND_ROOT = Path(__file__).resolve().parents[1]
sys.path.append(str(BACKEND_ROOT))

from app.database.session import SessionLocal, init_database
from app.ingestion.database_loader import load_processed_chunks_to_database
from app.ingestion.pipeline import run_pdf_processing
from app.services.database_seed import seed_knowledge_base


def main() -> None:
    init_database()
    manifest = run_pdf_processing()

    with SessionLocal() as db:
        seed_knowledge_base(db)
        db_summary = load_processed_chunks_to_database(db)

    print(
        {
            "procesamiento": manifest,
            "base_datos": db_summary,
        }
    )


if __name__ == "__main__":
    main()
