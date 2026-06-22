from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.repositories.knowledge_repository import KnowledgeRepository
from app.schemas.knowledge_base import (
    KnowledgeBaseResponse,
    KnowledgeBaseSummaryResponse,
    KnowledgeSourceResponse,
    SemanticRelationResponse,
)

router = APIRouter(prefix="/base-conocimiento", tags=["base de conocimiento"])


@router.get("/resumen", response_model=KnowledgeBaseSummaryResponse)
def knowledge_base_summary(
    db: Session = Depends(get_db),
) -> KnowledgeBaseSummaryResponse:
    repository = KnowledgeRepository(db)
    return KnowledgeBaseSummaryResponse(
        **repository.summary(),
        descripcion=(
            "Base de conocimiento semantica con medicamentos, fuentes y relaciones "
            "farmacologicas para alimentar el agente de busqueda."
        ),
    )


@router.get("/fuentes", response_model=list[KnowledgeSourceResponse])
def knowledge_sources(db: Session = Depends(get_db)) -> list[KnowledgeSourceResponse]:
    repository = KnowledgeRepository(db)
    return [KnowledgeSourceResponse(**source) for source in repository.list_sources()]


@router.get("/relaciones", response_model=list[SemanticRelationResponse])
def semantic_relations(
    db: Session = Depends(get_db),
) -> list[SemanticRelationResponse]:
    repository = KnowledgeRepository(db)
    return [
        SemanticRelationResponse(**relation)
        for relation in repository.list_relations()
    ]


@router.get("", response_model=KnowledgeBaseResponse)
def knowledge_base(db: Session = Depends(get_db)) -> KnowledgeBaseResponse:
    repository = KnowledgeRepository(db)
    summary = KnowledgeBaseSummaryResponse(
        **repository.summary(),
        descripcion=(
            "Base de conocimiento semantica con medicamentos, fuentes y relaciones "
            "farmacologicas para alimentar el agente de busqueda."
        ),
    )

    return KnowledgeBaseResponse(
        resumen=summary,
        fuentes=[
            KnowledgeSourceResponse(**source)
            for source in repository.list_sources()
        ],
        relaciones=[
            SemanticRelationResponse(**relation)
            for relation in repository.list_relations()
        ],
    )
