from pathlib import Path
import sys

BACKEND_ROOT = Path(__file__).resolve().parents[1]
sys.path.append(str(BACKEND_ROOT))

from app.database.session import SessionLocal, init_database
from app.models.medicine import Medicine


def main() -> None:
    init_database()
    with SessionLocal() as db:
        deleted = db.query(Medicine).delete()
        db.commit()
    print({"medicines_eliminados": deleted})


if __name__ == "__main__":
    main()
