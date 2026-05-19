# busqueda-semantica-farmacos

Prototipo inicial de aplicación móvil con búsqueda semántica para consulta de información farmacológica.

## Estructura

- `backend_fastapi/`: API REST con FastAPI para consulta semántica.
- `base_conocimiento/`: archivo JSON con medicamentos de ejemplo.
- `frontend_movil/`: aplicación Flutter del prototipo móvil.
- `evidencias/`: carpeta para guardar capturas de pantalla del proyecto.

## Backend

```bash
cd backend_fastapi
py -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

Prueba:

```text
http://127.0.0.1:8000/buscar?q=medicamento%20para%20fiebre
```

## Frontend

```bash
cd frontend_movil
flutter run -d chrome
```
