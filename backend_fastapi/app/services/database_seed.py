from sqlalchemy.orm import Session

from app.repositories.knowledge_repository import KnowledgeRepository
from app.repositories.medicine_repository import MedicineRepository
from app.services.document_builder import build_medicine_document
from app.services.embedding_service import generate_embedding
from app.services.knowledge_base import (
    load_medicines,
    load_semantic_relations,
    load_sources,
)


def seed_knowledge_base(db: Session) -> None:
    medicine_repository = MedicineRepository(db)
    knowledge_repository = KnowledgeRepository(db)

    if medicine_repository.count() == 0:
        for medicine in load_medicines():
            document = build_medicine_document(medicine)
            medicine_repository.add(
                medicine_data=medicine,
                document=document,
                embedding=generate_embedding(document),
            )

    if knowledge_repository.count_sources() == 0:
        for source in load_sources():
            knowledge_repository.add_source(source)

    if knowledge_repository.count_relations() == 0:
        for relation in load_semantic_relations():
            knowledge_repository.add_relation(relation)

    db.commit()
