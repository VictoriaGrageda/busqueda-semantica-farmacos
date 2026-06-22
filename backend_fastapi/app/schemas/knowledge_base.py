from pydantic import BaseModel


class KnowledgeSourceResponse(BaseModel):
    id: int
    codigo: str
    nombre: str
    tipo: str
    descripcion: str
    estado: str


class SemanticRelationResponse(BaseModel):
    id: int
    origen: str
    tipo_relacion: str
    destino: str
    descripcion: str


class KnowledgeBaseSummaryResponse(BaseModel):
    medicamentos: int
    fuentes: int
    relaciones_semanticas: int
    descripcion: str


class KnowledgeBaseResponse(BaseModel):
    resumen: KnowledgeBaseSummaryResponse
    fuentes: list[KnowledgeSourceResponse]
    relaciones: list[SemanticRelationResponse]
