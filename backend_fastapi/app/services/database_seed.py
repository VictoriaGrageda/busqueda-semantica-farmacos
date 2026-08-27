from sqlalchemy.orm import Session

from app.repositories.knowledge_repository import KnowledgeRepository
from app.services.knowledge_base import (
    load_semantic_relations,
    load_sources,
)


def seed_knowledge_base(db: Session) -> None:
    knowledge_repository = KnowledgeRepository(db)

    if knowledge_repository.count_sources() == 0:
        for source in load_sources():
            knowledge_repository.add_source(source)

    if knowledge_repository.count_relations() == 0:
        for relation in load_semantic_relations():
            knowledge_repository.add_relation(relation)

    db.commit()
