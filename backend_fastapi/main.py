from pathlib import Path
import json
import re
import unicodedata

from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
from rapidfuzz import fuzz
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

app = FastAPI(
    title="Agente de búsqueda semántico farmacológico",
    description="Prototipo inicial para búsqueda de información farmacológica.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_PATH = Path(__file__).resolve().parent.parent / "base_conocimiento" / "medicamentos.json"


def normalizar_texto(texto: str) -> str:
    texto = texto.lower()
    texto = unicodedata.normalize("NFD", texto)
    texto = "".join(caracter for caracter in texto if unicodedata.category(caracter) != "Mn")
    texto = re.sub(r"[^a-z0-9ñ\s]", " ", texto)
    texto = re.sub(r"\s+", " ", texto).strip()
    return texto


def cargar_medicamentos() -> list[dict]:
    with open(BASE_PATH, "r", encoding="utf-8") as archivo:
        return json.load(archivo)


medicamentos = cargar_medicamentos()


def construir_documento(medicamento: dict) -> str:
    partes = [
        medicamento["medicamento"],
        medicamento["principio_activo"],
        medicamento["grupo_farmacologico"],
        " ".join(medicamento["indicaciones"]),
        " ".join(medicamento["contraindicaciones"]),
        " ".join(medicamento["reacciones_adversas"]),
        " ".join(medicamento["via_administracion"]),
        " ".join(medicamento["forma_farmaceutica"]),
    ]
    return normalizar_texto(" ".join(partes))


documentos = [construir_documento(med) for med in medicamentos]
vectorizador = TfidfVectorizer()
matriz_tfidf = vectorizador.fit_transform(documentos)


@app.get("/")
def inicio():
    return {
        "mensaje": "Backend funcionando correctamente",
        "endpoint_busqueda": "/buscar?q=medicamento para fiebre",
    }


@app.get("/buscar")
def buscar(q: str = Query(..., min_length=1)):
    consulta_normalizada = normalizar_texto(q)
    vector_consulta = vectorizador.transform([consulta_normalizada])
    similitudes = cosine_similarity(vector_consulta, matriz_tfidf)[0]

    resultados = []

    for indice, medicamento in enumerate(medicamentos):
        nombre = normalizar_texto(medicamento["medicamento"])
        principio = normalizar_texto(medicamento["principio_activo"])

        coincidencia_nombre = max(
            fuzz.ratio(consulta_normalizada, nombre),
            fuzz.ratio(consulta_normalizada, principio),
        ) / 100
        similitud_aproximada = coincidencia_nombre if coincidencia_nombre >= 0.75 else 0

        similitud_semantica = float(similitudes[indice])
        puntaje = max(similitud_semantica, similitud_aproximada)

        if puntaje >= 0.15:
            resultados.append(
                {
                    "puntaje": round(puntaje, 2),
                    "medicamento": medicamento["medicamento"],
                    "principio_activo": medicamento["principio_activo"],
                    "grupo_farmacologico": medicamento["grupo_farmacologico"],
                    "indicaciones": medicamento["indicaciones"],
                    "contraindicaciones": medicamento["contraindicaciones"],
                    "reacciones_adversas": medicamento["reacciones_adversas"],
                    "via_administracion": medicamento["via_administracion"],
                    "forma_farmaceutica": medicamento["forma_farmaceutica"],
                }
            )

    resultados = sorted(resultados, key=lambda item: item["puntaje"], reverse=True)

    return {
        "consulta_original": q,
        "consulta_normalizada": consulta_normalizada,
        "cantidad_resultados": len(resultados),
        "resultados": resultados[:3],
    }
