from sqlalchemy import Integer, String, Text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from pgvector.sqlalchemy import Vector

from app.core.config import EMBEDDING_DIMENSIONS
from app.database.session import Base


class Medicine(Base):
    __tablename__ = "medicines"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    medicamento: Mapped[str] = mapped_column(String(160), unique=True, index=True)
    principio_activo: Mapped[str] = mapped_column(String(160), index=True)
    grupo_farmacologico: Mapped[str] = mapped_column(String(220), index=True)
    mecanismo_accion: Mapped[str | None] = mapped_column(Text, nullable=True)
    indicaciones: Mapped[list[str]] = mapped_column(JSONB, default=list)
    contraindicaciones: Mapped[list[str]] = mapped_column(JSONB, default=list)
    reacciones_adversas: Mapped[list[str]] = mapped_column(JSONB, default=list)
    interacciones: Mapped[list[str]] = mapped_column(JSONB, default=list)
    via_administracion: Mapped[list[str]] = mapped_column(JSONB, default=list)
    forma_farmaceutica: Mapped[list[str]] = mapped_column(JSONB, default=list)
    fuentes: Mapped[list[str]] = mapped_column(JSONB, default=list)
    documento_busqueda: Mapped[str] = mapped_column(Text)
    embedding: Mapped[list[float]] = mapped_column(Vector(EMBEDDING_DIMENSIONS))

    def to_dict(self, score: float | None = None) -> dict:
        return {
            "id": self.id,
            "puntaje": score if score is not None else 0,
            "medicamento": self.medicamento,
            "principio_activo": self.principio_activo,
            "grupo_farmacologico": self.grupo_farmacologico,
            "mecanismo_accion": self.mecanismo_accion,
            "indicaciones": self.indicaciones,
            "contraindicaciones": self.contraindicaciones,
            "reacciones_adversas": self.reacciones_adversas,
            "interacciones": self.interacciones,
            "via_administracion": self.via_administracion,
            "forma_farmaceutica": self.forma_farmaceutica,
            "fuentes": self.fuentes,
        }
