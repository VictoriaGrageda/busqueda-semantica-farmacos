from typing import Any

from app.services.text_normalizer import normalize_text


def build_medicine_document(medicine: dict[str, Any]) -> str:
    parts = [
        medicine["medicamento"],
        medicine["principio_activo"],
        medicine["grupo_farmacologico"],
        medicine.get("mecanismo_accion", ""),
        " ".join(medicine["indicaciones"]),
        " ".join(medicine["contraindicaciones"]),
        " ".join(medicine["reacciones_adversas"]),
        " ".join(medicine.get("interacciones", [])),
        " ".join(medicine["via_administracion"]),
        " ".join(medicine["forma_farmaceutica"]),
        " ".join(medicine.get("fuentes", [])),
    ]
    return normalize_text(" ".join(parts))
