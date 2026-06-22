from rapidfuzz import fuzz

from app.repositories.medicine_repository import MedicineRepository
from app.services.embedding_service import generate_embedding
from app.services.text_normalizer import normalize_text


class SemanticMedicineSearchEngine:
    def __init__(self, repository: MedicineRepository) -> None:
        self._repository = repository

    def search(self, query: str, limit: int = 3) -> dict:
        normalized_query = normalize_text(query)
        query_embedding = generate_embedding(normalized_query)

        semantic_results = self._repository.search_by_embedding(
            embedding=query_embedding,
            limit=max(limit * 4, 10),
        )
        all_medicines = self._repository.list_all()

        combined_results = self._combine_scores(
            normalized_query=normalized_query,
            semantic_results=semantic_results,
            medicines=all_medicines,
        )

        filtered_results = [
            result for result in combined_results if result["puntaje"] >= 0.15
        ]
        sorted_results = sorted(
            filtered_results,
            key=lambda item: item["puntaje"],
            reverse=True,
        )

        return {
            "consulta_original": query,
            "consulta_normalizada": normalized_query,
            "cantidad_resultados": len(sorted_results),
            "resultados": sorted_results[:limit],
        }

    def _combine_scores(
        self,
        normalized_query: str,
        semantic_results: list[dict],
        medicines: list[dict],
    ) -> list[dict]:
        results_by_id = {
            result["id"]: {**result, "puntaje": float(result["puntaje"] or 0)}
            for result in semantic_results
        }

        for medicine in medicines:
            fuzzy_score = self._fuzzy_name_score(normalized_query, medicine)
            current = results_by_id.get(medicine["id"], {**medicine, "puntaje": 0})
            current["puntaje"] = round(max(current["puntaje"], fuzzy_score), 2)
            results_by_id[medicine["id"]] = current

        return list(results_by_id.values())

    def _fuzzy_name_score(self, normalized_query: str, medicine: dict) -> float:
        name = normalize_text(medicine["medicamento"])
        active_ingredient = normalize_text(medicine["principio_activo"])
        score = max(
            fuzz.ratio(normalized_query, name),
            fuzz.ratio(normalized_query, active_ingredient),
        )
        normalized_score = score / 100
        return normalized_score if normalized_score >= 0.75 else 0
