# backend_fastapi

API REST con FastAPI para consultar una base de conocimiento farmacologica.

## Carpetas principales

- `app/main.py`: creacion de la aplicacion FastAPI.
- `app/api/routes/`: endpoints HTTP.
- `app/agents/`: agente de busqueda semantica.
- `app/core/`: configuracion y constantes.
- `app/database/`: conexion a PostgreSQL, creacion de extension pgvector e inicializacion.
- `app/models/`: modelos SQLAlchemy.
- `app/repositories/`: acceso a datos.
- `app/schemas/`: contratos de entrada/salida con Pydantic.
- `app/services/`: logica de negocio, normalizacion y motor de busqueda.
- `tests/`: pruebas automatizadas del backend.

## Base de datos

El backend usa PostgreSQL con `pgvector`.

Tablas principales:

```text
medicines
knowledge_documents
knowledge_chunks
knowledge_sources
semantic_relations
```

`medicines` almacena fichas de medicamentos extraidas automaticamente desde los PDFs. `knowledge_chunks` incluye fragmentos extraidos de manuales y un campo `embedding` para busqueda vectorial.

El seed inicial de metadatos se carga desde:

```text
../base_conocimiento/data/fuentes.json
../base_conocimiento/data/relaciones_farmacologicas.json
```

La carga documental y estructurada se realiza con el pipeline de ingesta de PDFs.

## Ingesta de manuales PDF

Los PDFs farmacologicos deben estar en:

```text
../base_conocimiento/sources/farmacologicas/manuales/
```

Para extraer texto, generar chunks, detectar campos farmacologicos, extraer medicamentos estructurados y cargar embeddings en PostgreSQL:

```powershell
docker compose exec backend python scripts/ingest_knowledge_sources.py
```

El resultado queda en:

```text
../base_conocimiento/processed/text/
../base_conocimiento/processed/chunks/
../base_conocimiento/processed/entities/
```

La tabla `medicines` se llena desde los PDFs; no requiere mantener un JSON manual de medicamentos.

Documento de referencia academica:

```text
../docs/base_conocimiento_semantica.md
```

## Correr con Docker

Desde la raiz del proyecto:

```powershell
docker compose up --build
```

Servicios:

```text
PostgreSQL + pgvector: localhost:5433 en la configuracion local actual
FastAPI: http://127.0.0.1:8000
```

## Comandos

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -U pip
pip install -r requirements.txt
set DATABASE_URL=postgresql+psycopg://postgres:2346@localhost:5433/postgres
python -m uvicorn app.main:app --reload
```

Endpoint principal:

```text
GET /buscar?q=medicamento para fiebre
GET /agente/buscar?q=para que sirve paracetamol
GET /base-conocimiento/resumen
GET /base-conocimiento/fuentes
GET /base-conocimiento/relaciones
```

`/buscar` devuelve resultados semanticos estructurados.
`/agente/buscar` analiza la consulta, detecta intencion, usa relaciones semanticas y genera una respuesta de apoyo academico basada en la base de conocimiento.
