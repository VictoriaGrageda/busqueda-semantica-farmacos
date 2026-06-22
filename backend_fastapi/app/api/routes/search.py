from fastapi import APIRouter, Query
from fastapi import Depends
from sqlalchemy.orm import Session

from app.schemas.search import HealthResponse, SearchResponse
from app.database.session import get_db
from app.repositories.medicine_repository import MedicineRepository
from app.services.search_engine import SemanticMedicineSearchEngine

router = APIRouter()


@router.get("/", response_model=HealthResponse)
def health_check() -> HealthResponse:
    return HealthResponse(
        mensaje="Backend funcionando correctamente",
        endpoint_busqueda="/buscar?q=medicamento para fiebre",
    )


@router.get("/buscar", response_model=SearchResponse)
def search(
    q: str = Query(..., min_length=1),
    db: Session = Depends(get_db),
) -> SearchResponse:
    search_engine = SemanticMedicineSearchEngine(MedicineRepository(db))
    return SearchResponse(**search_engine.search(q))
