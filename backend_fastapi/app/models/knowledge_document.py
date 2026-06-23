from sqlalchemy import Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database.session import Base


class KnowledgeDocument(Base):
    __tablename__ = "knowledge_documents"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    titulo: Mapped[str] = mapped_column(String(260), index=True)
    tipo_fuente: Mapped[str] = mapped_column(String(120), index=True)
    ruta_archivo: Mapped[str] = mapped_column(Text, unique=True)
    ruta_texto_procesado: Mapped[str] = mapped_column(Text)
    paginas: Mapped[int] = mapped_column(Integer)
    estado: Mapped[str] = mapped_column(String(80), index=True)

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "titulo": self.titulo,
            "tipo_fuente": self.tipo_fuente,
            "ruta_archivo": self.ruta_archivo,
            "ruta_texto_procesado": self.ruta_texto_procesado,
            "paginas": self.paginas,
            "estado": self.estado,
        }
