from typing import Any

from app.repositories.knowledge_repository import KnowledgeRepository
from app.services.document_search_service import DocumentSearchService
from app.services.query_analyzer import QueryAnalyzer
from app.services.search_engine import SemanticMedicineSearchEngine


class SemanticSearchAgent:
    def __init__(
        self,
        search_engine: SemanticMedicineSearchEngine,
        knowledge_repository: KnowledgeRepository,
        document_search_service: DocumentSearchService,
    ) -> None:
        self._search_engine = search_engine
        self._knowledge_repository = knowledge_repository
        self._document_search_service = document_search_service
        self._query_analyzer = QueryAnalyzer()

    def answer(self, query: str) -> dict[str, Any]:
        search_response = self._search_engine.search(query)
        intent = self._query_analyzer.detect_intent(query)
        results = search_response["resultados"]
        context_relations = self._get_context_relations(results)
        document_context = self._document_search_service.search(query)

        return {
            **search_response,
            "tipo_consulta": intent,
            "respuesta_agente": self._build_answer(intent, results, document_context),
            "relaciones_contexto": context_relations,
            "documentos_contexto": document_context,
            "recomendaciones": self._build_recommendations(intent),
            "advertencia": (
                "Informacion de apoyo academico. No reemplaza la revision de fuentes "
                "oficiales, bibliografia farmacologica ni criterio profesional."
            ),
        }

    def _get_context_relations(self, results: list[dict[str, Any]]) -> list[dict]:
        if not results:
            return []

        top_result = results[0]
        return self._knowledge_repository.find_relations_for_origin(
            origin=top_result["medicamento"]
        )

    def _build_answer(
        self,
        intent: str,
        results: list[dict[str, Any]],
        document_context: list[dict],
    ) -> str:
        if not results and document_context:
            top_context = document_context[0]
            return (
                "Se encontro contenido relacionado en la base de conocimiento documental: "
                f"{top_context['documento']} "
                f"(paginas {top_context['pagina_inicio']}-{top_context['pagina_fin']}). "
                "Revisa el fragmento mostrado para contrastar la informacion."
            )

        if not results:
            return (
                "No se encontro una coincidencia suficiente en la base de conocimiento. "
                "Prueba con el nombre del medicamento, principio activo, indicacion o "
                "grupo farmacologico."
            )

        top_result = results[0]
        medicine = top_result["medicamento"]

        if document_context:
            top_context = document_context[0]
            evidence = (
                f" Tambien hay contexto documental en {top_context['documento']} "
                f"(paginas {top_context['pagina_inicio']}-{top_context['pagina_fin']})."
            )
        else:
            evidence = ""

        if intent == "indicaciones":
            return (
                f"{medicine} se relaciona principalmente con estas indicaciones: "
                f"{', '.join(top_result['indicaciones'])}.{evidence}"
            )
        if intent == "contraindicaciones":
            return (
                f"Para {medicine}, las contraindicaciones registradas son: "
                f"{', '.join(top_result['contraindicaciones'])}.{evidence}"
            )
        if intent == "reacciones_adversas":
            return (
                f"Las reacciones adversas registradas para {medicine} son: "
                f"{', '.join(top_result['reacciones_adversas'])}.{evidence}"
            )
        if intent == "interacciones":
            interactions = top_result.get("interacciones") or ["sin interacciones registradas"]
            return (
                f"Sobre interacciones de {medicine}, la base registra: "
                f"{', '.join(interactions)}."
            )
        if intent == "via_administracion":
            return (
                f"La via de administracion registrada para {medicine} es: "
                f"{', '.join(top_result['via_administracion'])}."
            )
        if intent == "forma_farmaceutica":
            return (
                f"Las formas farmaceuticas registradas para {medicine} son: "
                f"{', '.join(top_result['forma_farmaceutica'])}."
            )
        if intent == "grupo_farmacologico":
            return (
                f"{medicine} pertenece al grupo farmacologico: "
                f"{top_result['grupo_farmacologico']}."
            )

        return (
            f"El resultado mas relacionado es {medicine}, cuyo principio activo es "
            f"{top_result['principio_activo']} y pertenece al grupo "
            f"{top_result['grupo_farmacologico']}."
        )

    def _build_recommendations(self, intent: str) -> list[str]:
        base_recommendations = [
            "Revisar indicaciones, contraindicaciones y reacciones adversas antes de usar la informacion.",
            "Contrastar la respuesta con fuentes oficiales o bibliografia de farmacologia.",
        ]

        if intent == "consulta_general":
            return [
                "Puedes buscar por medicamento, principio activo, indicacion o grupo farmacologico.",
                *base_recommendations,
            ]

        return base_recommendations
