from pydantic import BaseModel, Field


class HealthResponse(BaseModel):
    mensaje: str
    endpoint_busqueda: str


class MedicineResult(BaseModel):
    puntaje: float
    medicamento: str
    principio_activo: str
    grupo_farmacologico: str
    mecanismo_accion: str | None = None
    indicaciones: list[str]
    contraindicaciones: list[str]
    reacciones_adversas: list[str]
    interacciones: list[str] = Field(default_factory=list)
    via_administracion: list[str]
    forma_farmaceutica: list[str]
    fuentes: list[str] = Field(default_factory=list)


class SearchResponse(BaseModel):
    consulta_original: str
    consulta_normalizada: str
    cantidad_resultados: int
    resultados: list[MedicineResult]


class AgentSearchResponse(SearchResponse):
    tipo_consulta: str
    respuesta_agente: str
    relaciones_contexto: list[dict]
    documentos_contexto: list[dict]
    recomendaciones: list[str]
    advertencia: str
