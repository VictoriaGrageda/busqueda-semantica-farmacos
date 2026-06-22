# Base de conocimiento

Esta carpeta contiene los datos usados por el motor de busqueda semantica.

## Carpetas

- `data/`: datos JSON limpios que consume el backend.
- `sources/`: documentos originales, fuentes externas o insumos sin procesar.
- `processed/`: archivos generados, indices, embeddings u otros resultados derivados.

El backend usa `data/medicamentos.json` como seed inicial para cargar PostgreSQL cuando la tabla `medicines` esta vacia.

## Estado actual

La base actual es un prototipo con medicamentos de ejemplo y relaciones como:

- medicamento
- principio activo
- grupo farmacologico
- mecanismo de accion
- indicaciones
- contraindicaciones
- reacciones adversas
- interacciones
- via de administracion
- forma farmaceutica
- fuentes

Para la version final se debe poblar PostgreSQL con informacion depurada desde fuentes oficiales seleccionadas.
