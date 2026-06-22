# backend_fastapi

API REST con FastAPI para buscar medicamentos en la base de conocimiento.

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

Tabla principal:

```text
medicines
```

Incluye datos farmacologicos estructurados y un campo `embedding` para busqueda vectorial.

El seed inicial se carga desde:

```text
../base_conocimiento/data/medicamentos.json
```

La carga se ejecuta automaticamente al iniciar el backend si la tabla esta vacia.

## Correr con Docker

Desde la raiz del proyecto:

```powershell
docker compose up --build
```

Servicios:

```text
PostgreSQL + pgvector: localhost:5432
FastAPI: http://127.0.0.1:8000
```

## Comandos

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -U pip
pip install -r requirements.txt
set DATABASE_URL=postgresql+psycopg://farmacos_user:farmacos_password@localhost:5432/farmacos_db
python -m uvicorn app.main:app --reload
```

Endpoint principal:

```text
GET /buscar?q=medicamento para fiebre
GET /agente/buscar?q=para que sirve paracetamol
```

`/buscar` devuelve resultados semanticos estructurados.
`/agente/buscar` analiza la consulta, detecta intencion y genera una respuesta de apoyo academico basada en la base de conocimiento.
