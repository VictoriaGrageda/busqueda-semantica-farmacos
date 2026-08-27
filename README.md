# busqueda-semantica-farmacos

Aplicacion con backend FastAPI, frontend Flutter y base de conocimiento separada
para busqueda semantica de informacion farmacologica.

## Estructura del proyecto

```text
busqueda-semantica-farmacos/
  backend_fastapi/
    app/
      api/
        routes/
      agents/
      core/
      database/
      models/
      repositories/
      schemas/
      services/
    tests/
    main.py
    requirements.txt
  base_conocimiento/
    data/
    sources/
    processed/
  frontend_movil/
    lib/
      app/
      config/
      models/
      screens/
      services/
      widgets/
    test/
    pubspec.yaml
```

## Responsabilidades

- `backend_fastapi/`: API REST, configuracion, rutas, schemas y logica de busqueda.
- `base_conocimiento/`: datos y archivos relacionados con la base de conocimiento.
- `frontend_movil/`: aplicacion Flutter, pantallas, widgets, modelos y cliente HTTP.

## Componentes del proyecto academico

- Aplicacion movil: implementada con Flutter en `frontend_movil/`.
- Backend: implementado con FastAPI en `backend_fastapi/`.
- Base de datos: PostgreSQL con extension pgvector.
- Base de conocimiento: manuales PDF procesados, medicamentos extraidos automaticamente, fuentes y relaciones semanticas.
- PLN: extraccion de texto, limpieza, segmentacion, deteccion de campos farmacologicos y estructuracion automatica de medicamentos desde PDFs.
- Busqueda semantica: busqueda vectorial sobre medicamentos y chunks de manuales con pgvector.
- Agente inteligente: endpoint `/agente/buscar` que analiza la intencion de la consulta, recupera informacion de la base de conocimiento, usa relaciones semanticas y genera una respuesta trazable.

La base de conocimiento actual se construye desde PDFs farmacologicos ubicados en `base_conocimiento/sources/farmacologicas/manuales/`. El Vademecum Farmaceutico esta registrado como fuente prevista y la arquitectura queda preparada para incorporarlo con el mismo pipeline de ingesta. La documentacion completa del criterio academico esta en `docs/base_conocimiento_semantica.md`.

## Arrancar prototipo completo

Requisito: Docker instalado.

```powershell
docker compose up --build
```

Esto levanta:

- PostgreSQL + pgvector. En la configuracion local actual se publica en `localhost:5433`.
- Backend FastAPI en `http://127.0.0.1:8000`.
- Seed inicial de fuentes y relaciones semanticas desde `base_conocimiento/data/`.

Para procesar y cargar manuales PDF de `base_conocimiento/sources/farmacologicas/manuales/`:

```powershell
docker compose exec backend python scripts/ingest_knowledge_sources.py
```

Ese comando procesa PDFs, genera chunks vectorizados, extrae medicamentos estructurados y carga todo en PostgreSQL.

Luego, en otra terminal:

```powershell
cd frontend_movil
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## Correr backend

Requisito: Python 3.11 o superior y PostgreSQL con pgvector activo.

```powershell
cd backend_fastapi
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -U pip
pip install -r requirements.txt
python -m uvicorn app.main:app --reload
```

Si usas Docker, no necesitas ejecutar estos comandos manuales para el backend.

Prueba:

```text
http://127.0.0.1:8000/
http://127.0.0.1:8000/buscar?q=medicamento%20para%20fiebre
http://127.0.0.1:8000/agente/buscar?q=para%20que%20sirve%20paracetamol
http://127.0.0.1:8000/base-conocimiento/resumen
```

## Correr frontend

Requisito: Flutter instalado.

```powershell
cd frontend_movil
flutter pub get
flutter run -d chrome
```

Para cambiar la URL del backend:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Si usas emulador Android, normalmente la URL del backend local es:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Validaciones

```powershell
cd frontend_movil
flutter test
flutter analyze
```
