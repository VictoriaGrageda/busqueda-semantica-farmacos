from fastapi import APIRouter, Query
from fastapi import Depends
from sqlalchemy.orm import Session

from app.agents.semantic_search_agent import SemanticSearchAgent
from app.database.session import get_db
from app.repositories.medicine_repository import MedicineRepository
from app.schemas.search import AgentSearchResponse
from app.services.search_engine import SemanticMedicineSearchEngine

router = APIRouter(prefix="/agente", tags=["agente semantico"])


@router.get("/buscar", response_model=AgentSearchResponse)
def agent_search(
    q: str = Query(..., min_length=1),
    db: Session = Depends(get_db),
) -> AgentSearchResponse:
    search_engine = SemanticMedicineSearchEngine(MedicineRepository(db))
    agent = SemanticSearchAgent(search_engine)
    return AgentSearchResponse(**agent.answer(q))
