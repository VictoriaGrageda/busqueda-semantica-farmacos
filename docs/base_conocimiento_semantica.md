# Base de conocimiento semantica

Este documento resume el criterio academico usado para organizar la base de conocimiento del prototipo.

## Alcance

La base de conocimiento integra:

- Fuentes farmacologicas registradas en `base_conocimiento/data/fuentes.json`.
- Relaciones semanticas iniciales en `base_conocimiento/data/relaciones_farmacologicas.json`.
- Manuales PDF ubicados en `base_conocimiento/sources/farmacologicas/manuales/`.
- Texto procesado, chunks y entidades generadas en `base_conocimiento/processed/`.

## Pipeline

El script `backend_fastapi/scripts/ingest_knowledge_sources.py` ejecuta el flujo de ingesta:

1. Extrae texto desde PDFs.
2. Limpia y segmenta el contenido en chunks.
3. Detecta campos farmacologicos.
4. Genera embeddings.
5. Carga documentos, chunks y medicamentos estructurados en PostgreSQL con pgvector.

## Uso de Vademecum

El Vademecum Farmaceutico esta registrado como fuente prevista. Para afirmar cobertura directa, debe agregarse el archivo o dataset correspondiente en `base_conocimiento/sources/` y ejecutarse el pipeline de ingesta.

## Limitacion

La busqueda semantica actual usa embeddings deterministas con `HashingVectorizer`, adecuados para prototipo academico offline. Para una version productiva se recomienda usar embeddings especializados y validar los datos contra fuentes oficiales.
