from sqlalchemy.orm import Session

from app.models.knowledge_source import KnowledgeSource
from app.models.medicine import Medicine
from app.models.semantic_relation import SemanticRelation


class KnowledgeRepository:
    def __init__(self, db: Session) -> None:
        self._db = db

    def count_sources(self) -> int:
        return self._db.query(KnowledgeSource).count()

    def count_relations(self) -> int:
        return self._db.query(SemanticRelation).count()

    def add_source(self, source_data: dict) -> None:
        self._db.add(
            KnowledgeSource(
                codigo=source_data["codigo"],
                nombre=source_data["nombre"],
                tipo=source_data["tipo"],
                descripcion=source_data["descripcion"],
                estado=source_data["estado"],
            )
        )

    def add_relation(self, relation_data: dict) -> None:
        self._db.add(
            SemanticRelation(
                origen=relation_data["origen"],
                tipo_relacion=relation_data["tipo_relacion"],
                destino=relation_data["destino"],
                descripcion=relation_data["descripcion"],
            )
        )

    def list_sources(self) -> list[dict]:
        sources = self._db.query(KnowledgeSource).order_by(KnowledgeSource.id.asc()).all()
        return [source.to_dict() for source in sources]

    def list_relations(self, limit: int = 100) -> list[dict]:
        relations = (
            self._db.query(SemanticRelation)
            .order_by(SemanticRelation.origen.asc(), SemanticRelation.tipo_relacion.asc())
            .limit(limit)
            .all()
        )
        return [relation.to_dict() for relation in relations]

    def find_relations_for_origin(self, origin: str, limit: int = 20) -> list[dict]:
        relations = (
            self._db.query(SemanticRelation)
            .filter(SemanticRelation.origen == origin)
            .order_by(SemanticRelation.tipo_relacion.asc(), SemanticRelation.destino.asc())
            .limit(limit)
            .all()
        )
        return [relation.to_dict() for relation in relations]

    def summary(self) -> dict:
        return {
            "medicamentos": self._db.query(Medicine).count(),
            "fuentes": self._db.query(KnowledgeSource).count(),
            "relaciones_semanticas": self._db.query(SemanticRelation).count(),
        }
