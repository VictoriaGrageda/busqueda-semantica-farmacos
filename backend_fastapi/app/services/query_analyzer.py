from app.services.text_normalizer import normalize_text


class QueryAnalyzer:
    _INTENT_KEYWORDS = {
        "contraindicaciones": ["contraindicacion", "no tomar", "evitar", "riesgo"],
        "indicaciones": ["sirve", "uso", "indicacion", "para que", "trata"],
        "reacciones_adversas": ["efecto", "adverso", "secundario", "reaccion"],
        "interacciones": ["interaccion", "combinar", "mezclar", "junto"],
        "via_administracion": ["via", "administracion", "tomar", "oral"],
        "forma_farmaceutica": ["forma", "presentacion", "tableta", "capsula", "jarabe"],
        "grupo_farmacologico": ["grupo", "familia", "clase"],
    }

    def detect_intent(self, query: str) -> str:
        normalized_query = normalize_text(query)

        for intent, keywords in self._INTENT_KEYWORDS.items():
            if any(keyword in normalized_query for keyword in keywords):
                return intent

        return "consulta_general"
