from app.services.text_normalizer import normalize_text

PHARMACOLOGY_FIELDS = {
    "indicaciones": ["indicacion", "indicaciones", "uso", "usos", "tratamiento"],
    "contraindicaciones": ["contraindicacion", "contraindicaciones", "no administrar"],
    "reacciones_adversas": ["reaccion adversa", "efecto adverso", "efectos secundarios"],
    "interacciones": ["interaccion", "interacciones"],
    "mecanismo_accion": ["mecanismo de accion", "accion farmacologica"],
    "dosis": ["dosis", "dosificacion"],
    "via_administracion": ["via de administracion", "administracion", "via oral"],
    "farmacocinetica": ["farmacocinetica", "absorcion", "distribucion", "metabolismo"],
}


def detect_chunk_entities(chunk_text: str) -> dict:
    normalized = normalize_text(chunk_text)
    fields = [
        field
        for field, keywords in PHARMACOLOGY_FIELDS.items()
        if any(keyword in normalized for keyword in keywords)
    ]

    return {
        "campos_detectados": sorted(set(fields)),
    }
