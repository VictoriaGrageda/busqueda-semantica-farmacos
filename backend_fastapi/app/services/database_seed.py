from sqlalchemy.orm import Session

from app.repositories.medicine_repository import MedicineRepository
from app.services.document_builder import build_medicine_document
from app.services.embedding_service import generate_embedding
from app.services.knowledge_base import load_medicines


def seed_knowledge_base(db: Session) -> None:
    repository = MedicineRepository(db)

    if repository.count() > 0:
        return

    for medicine in load_medicines():
        document = build_medicine_document(medicine)
        repository.add(
            medicine_data=medicine,
            document=document,
            embedding=generate_embedding(document),
        )

    db.commit()
