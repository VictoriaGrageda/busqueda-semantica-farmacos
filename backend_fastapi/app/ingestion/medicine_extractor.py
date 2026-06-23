import re
from pathlib import Path
from typing import Any

from app.core.config import PROCESSED_TEXT_PATH
from app.services.text_normalizer import normalize_text


FIELD_ALIASES = {
    "forma_farmaceutica": {"presentacion", "presentaciones"},
    "indicaciones": {"indicacion", "indicaciones"},
    "contraindicaciones": {"contraindicacion", "contraindicaciones"},
    "reacciones_adversas": {
        "efecto adverso",
        "efectos adversos",
        "reaccion adversa",
        "reacciones adversas",
    },
    "interacciones": {"interaccion", "interacciones"},
    "mecanismo_accion": {"farmacodinamia", "mecanismo de accion"},
    "via_administracion": {"administracion", "via de administracion"},
}

FIELD_BY_ALIAS = {
    alias: field
    for field, aliases in FIELD_ALIASES.items()
    for alias in aliases
}

STOP_SECTION_ALIASES = {
    "absorcion",
    "biodisponibilidad",
    "c d",
    "componentes",
    "dosis",
    "eliminacion",
    "eliminacion excrecion",
    "excrecion",
    "farmacocinetica",
    "liberacion",
    "metabolismo",
    "osmolaridad",
    "posologia",
    "redistribucion",
    "v 1 2",
}

NOISE_LINES = {
    "manual de farmacologia clinica",
    "victor alejandro hernandez vazquez",
    "m e julieta solis ornelas",
    "pagina",
}


def extract_medicines_from_processed_texts(
    text_dir: Path = PROCESSED_TEXT_PATH,
) -> list[dict[str, Any]]:
    medicines_by_name: dict[str, dict[str, Any]] = {}

    for text_file in sorted(text_dir.glob("*.txt")):
        text = _repair_mojibake(text_file.read_text(encoding="utf-8"))
        extracted = _extract_from_text(text, source_name=text_file.stem)

        for medicine in extracted:
            normalized_name = normalize_text(medicine["medicamento"])
            current = medicines_by_name.get(normalized_name)
            if current is None:
                medicines_by_name[normalized_name] = medicine
                continue
            medicines_by_name[normalized_name] = _merge_medicines(current, medicine)

    medicines = sorted(
        medicines_by_name.values(),
        key=lambda item: normalize_text(item["medicamento"]),
    )
    return medicines


def _extract_from_text(text: str, source_name: str) -> list[dict[str, Any]]:
    lines = [_clean_line(line) for line in text.splitlines()]
    lines = [line for line in lines if line]
    starts = _find_record_starts(lines)
    medicines = []

    for index, start in enumerate(starts):
        end = starts[index + 1] if index + 1 < len(starts) else len(lines)
        block = lines[start:end]
        medicine = _build_medicine(block, source_name)
        if medicine is not None:
            medicines.append(medicine)

    return medicines


def _find_record_starts(lines: list[str]) -> list[int]:
    starts = []

    for index, line in enumerate(lines[:-1]):
        if not _is_title_candidate(line):
            continue

        next_lines = lines[index + 1 : index + 4]
        if any(_field_for_line(next_line) == "forma_farmaceutica" for next_line in next_lines):
            starts.append(index)

    return starts


def _build_medicine(block: list[str], source_name: str) -> dict[str, Any] | None:
    if len(block) < 4:
        return None

    name = block[0].strip()
    sections = _parse_sections(block[1:])
    if not _has_minimum_content(sections):
        return None

    forma_farmaceutica = _section_items(sections, "forma_farmaceutica")
    indicaciones = _section_items(sections, "indicaciones")
    contraindicaciones = _section_items(sections, "contraindicaciones")
    reacciones_adversas = _section_items(sections, "reacciones_adversas")
    interacciones = _section_items(sections, "interacciones")
    via_administracion = _section_items(sections, "via_administracion")
    mecanismo_accion = _section_text(sections, "mecanismo_accion")

    inferred_routes = _infer_routes(forma_farmaceutica + via_administracion)
    via_administracion = _unique_nonempty([*via_administracion, *inferred_routes])

    return {
        "medicamento": name,
        "principio_activo": name,
        "grupo_farmacologico": "Extraido desde manual farmacologico",
        "mecanismo_accion": mecanismo_accion or None,
        "indicaciones": indicaciones,
        "contraindicaciones": contraindicaciones,
        "reacciones_adversas": reacciones_adversas,
        "interacciones": interacciones,
        "via_administracion": via_administracion,
        "forma_farmaceutica": forma_farmaceutica,
        "fuentes": [source_name],
        "documento_busqueda": _build_search_document(
            name=name,
            mechanism=mecanismo_accion,
            indications=indicaciones,
            contraindications=contraindicaciones,
            adverse_reactions=reacciones_adversas,
            interactions=interacciones,
            routes=via_administracion,
            pharmaceutical_forms=forma_farmaceutica,
        ),
    }


def _parse_sections(lines: list[str]) -> dict[str, list[str]]:
    sections: dict[str, list[str]] = {}
    current_field: str | None = None

    for line in lines:
        field = _field_for_line(line)
        if field == "__stop__":
            current_field = None
            continue

        if field is not None:
            current_field = field
            remainder = _strip_field_label(line)
            if remainder:
                sections.setdefault(current_field, []).append(remainder)
            continue

        if current_field is None or _is_noise(line):
            continue

        if _looks_like_page_marker(line):
            continue

        sections.setdefault(current_field, []).append(line)

    return sections


def _field_for_line(line: str) -> str | None:
    normalized = normalize_text(_repair_mojibake(line))
    normalized = re.sub(r"\s+", " ", normalized).strip()

    if normalized in FIELD_BY_ALIAS:
        return FIELD_BY_ALIAS[normalized]

    if normalized in STOP_SECTION_ALIASES:
        return "__stop__"

    for alias, field in FIELD_BY_ALIAS.items():
        if normalized.startswith(f"{alias} "):
            return field
        if normalized.startswith(f"{alias}:"):
            return field

    for alias in STOP_SECTION_ALIASES:
        if normalized.startswith(f"{alias} ") or normalized.startswith(f"{alias}:"):
            return "__stop__"

    return None


def _strip_field_label(line: str) -> str:
    normalized = normalize_text(line)
    for alias in sorted(FIELD_BY_ALIAS, key=len, reverse=True):
        if normalized == alias:
            return ""
        if normalized.startswith(alias):
            return re.sub(re.escape(alias), "", line, count=1, flags=re.IGNORECASE).strip(" :.-")
    return ""


def _section_items(sections: dict[str, list[str]], field: str) -> list[str]:
    return _unique_nonempty(
        _clean_item(item)
        for item in sections.get(field, [])
        if len(_clean_item(item)) >= 3
    )[:8]


def _section_text(sections: dict[str, list[str]], field: str) -> str:
    items = _section_items(sections, field)
    text = " ".join(items)
    return text[:700].strip()


def _build_search_document(
    name: str,
    mechanism: str,
    indications: list[str],
    contraindications: list[str],
    adverse_reactions: list[str],
    interactions: list[str],
    routes: list[str],
    pharmaceutical_forms: list[str],
) -> str:
    parts = [
        name,
        mechanism,
        " ".join(indications),
        " ".join(contraindications),
        " ".join(adverse_reactions),
        " ".join(interactions),
        " ".join(routes),
        " ".join(pharmaceutical_forms),
    ]
    return " ".join(part for part in parts if part).strip()


def _merge_medicines(
    current: dict[str, Any],
    new: dict[str, Any],
) -> dict[str, Any]:
    merged = {**current}
    for field in (
        "indicaciones",
        "contraindicaciones",
        "reacciones_adversas",
        "interacciones",
        "via_administracion",
        "forma_farmaceutica",
        "fuentes",
    ):
        merged[field] = _unique_nonempty([*current.get(field, []), *new.get(field, [])])

    if not merged.get("mecanismo_accion") and new.get("mecanismo_accion"):
        merged["mecanismo_accion"] = new["mecanismo_accion"]

    merged["documento_busqueda"] = _build_search_document(
        name=merged["medicamento"],
        mechanism=merged.get("mecanismo_accion") or "",
        indications=merged["indicaciones"],
        contraindications=merged["contraindicaciones"],
        adverse_reactions=merged["reacciones_adversas"],
        interactions=merged["interacciones"],
        routes=merged["via_administracion"],
        pharmaceutical_forms=merged["forma_farmaceutica"],
    )
    return merged


def _has_minimum_content(sections: dict[str, list[str]]) -> bool:
    useful_fields = {
        "forma_farmaceutica",
        "indicaciones",
        "contraindicaciones",
        "reacciones_adversas",
        "mecanismo_accion",
    }
    return sum(1 for field in useful_fields if sections.get(field)) >= 2


def _is_title_candidate(line: str) -> bool:
    normalized = normalize_text(line)
    if _is_noise(line) or _looks_like_page_marker(line):
        return False
    if _field_for_line(line) is not None:
        return False
    if len(line) < 3 or len(line) > 90:
        return False
    if len(normalized.split()) > 8:
        return False
    if re.search(r"[.:;]$", line):
        return False
    if not re.search(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]", line):
        return False
    return True


def _is_noise(line: str) -> bool:
    normalized = normalize_text(line)
    return normalized in NOISE_LINES


def _looks_like_page_marker(line: str) -> bool:
    return bool(re.fullmatch(r"\d{1,4}", line.strip()))


def _clean_line(line: str) -> str:
    line = _repair_mojibake(line)
    line = line.replace("\x00", " ")
    line = re.sub(r"\s+", " ", line)
    return line.strip()


def _clean_item(item: str) -> str:
    cleaned = _repair_mojibake(item)
    cleaned = re.sub(r"^[•\-\*\u2022xX]+\s*", "", cleaned)
    cleaned = re.sub(r"\s+", " ", cleaned)
    return cleaned.strip(" :;.-")


def _infer_routes(items: list[str]) -> list[str]:
    text = normalize_text(" ".join(items))
    routes = []
    route_terms = {
        "oral": "Oral",
        "intravenosa": "Intravenosa",
        "intraveosa": "Intravenosa",
        "intramuscular": "Intramuscular",
        "subcutanea": "Subcutanea",
        "topica": "Topica",
        "inhalatoria": "Inhalatoria",
        "oftalmica": "Oftalmica",
        "otica": "Otica",
        "rectal": "Rectal",
        "vaginal": "Vaginal",
    }
    for term, label in route_terms.items():
        if term in text:
            routes.append(label)
    return routes


def _unique_nonempty(items: Any) -> list[str]:
    unique = []
    seen = set()
    for item in items:
        if not item:
            continue
        cleaned = str(item).strip()
        key = normalize_text(cleaned)
        if not key or key in seen:
            continue
        seen.add(key)
        unique.append(cleaned)
    return unique


def _repair_mojibake(text: str) -> str:
    if "Ã" not in text and "Â" not in text and "â" not in text:
        return text

    try:
        repaired = text.encode("latin-1").decode("utf-8")
    except UnicodeError:
        return text

    if repaired.count("�") > text.count("�"):
        return text
    return repaired
