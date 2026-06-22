# Base de conocimiento

Esta carpeta contiene los datos usados por el motor de busqueda semantica.

## Carpetas

- `data/`: datos JSON limpios que consume el backend.
- `sources/`: documentos originales, fuentes externas o insumos sin procesar.
- `processed/`: archivos generados, indices, embeddings u otros resultados derivados.

El backend usa estos archivos como seed inicial para cargar PostgreSQL cuando las tablas estan vacias:

- `data/medicamentos.json`: entidades farmacologicas principales.
- `data/fuentes.json`: fuentes previstas y estado de carga.
- `data/relaciones_farmacologicas.json`: relaciones semanticas entre conceptos.

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

## Relaciones semanticas

Las relaciones permiten que el agente no dependa solo de coincidencias de texto. Ejemplos:

- `Paracetamol indicado_para fiebre`
- `Ibuprofeno contraindicado_en ulcera gastrica activa`
- `Metformina pertenece_a_grupo Antidiabetico oral`
