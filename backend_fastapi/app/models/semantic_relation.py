from sqlalchemy import Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database.session import Base


class SemanticRelation(Base):
    __tablename__ = "semantic_relations"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    origen: Mapped[str] = mapped_column(String(180), index=True)
    tipo_relacion: Mapped[str] = mapped_column(String(100), index=True)
    destino: Mapped[str] = mapped_column(String(220), index=True)
    descripcion: Mapped[str] = mapped_column(Text)

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "origen": self.origen,
            "tipo_relacion": self.tipo_relacion,
            "destino": self.destino,
            "descripcion": self.descripcion,
        }
