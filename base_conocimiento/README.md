# Base de conocimiento

Esta carpeta contiene los datos usados por el motor de busqueda semantica.

## Carpetas

- `data/`: datos JSON limpios que consume el backend.
- `sources/`: documentos originales, fuentes externas o insumos sin procesar.
- `processed/`: archivos generados, indices, embeddings u otros resultados derivados.

El backend usa estos archivos como seed inicial para cargar metadatos en PostgreSQL cuando las tablas estan vacias:

- `data/fuentes.json`: fuentes previstas y estado de carga.
- `data/relaciones_farmacologicas.json`: relaciones semanticas entre conceptos.

## Estado actual

La base actual se alimenta principalmente desde manuales PDF procesados. El pipeline genera chunks vectorizados que el agente consulta semanticamente y tambien extrae medicamentos estructurados hacia la tabla `medicines`.

Los JSON en `data/` contienen metadatos de fuentes y relaciones iniciales; no son la fuente principal de medicamentos. Los medicamentos se extraen automaticamente desde los documentos fuente mediante el pipeline de PLN.

El Vademecum Farmaceutico esta registrado como fuente prevista. Para afirmar cumplimiento literal con Vademecum debe cargarse el archivo o dataset correspondiente y ejecutar el mismo pipeline.

Documento completo de cumplimiento:

```text
../docs/base_conocimiento_semantica.md
```

## Relaciones semanticas

Las relaciones permiten que el agente no dependa solo de coincidencias de texto. Ejemplos:

- `Paracetamol indicado_para fiebre`
- `Ibuprofeno contraindicado_en ulcera gastrica activa`
- `Metformina pertenece_a_grupo Antidiabetico oral`

## Pipeline de ingesta de PDFs

Los manuales farmacologicos originales se colocan en:

```text
sources/farmacologicas/manuales/
```

El pipeline genera:

```text
processed/text/      texto limpio extraido de cada PDF
processed/chunks/    fragmentos listos para embeddings
processed/entities/  deteccion inicial de medicamentos y campos farmacologicos
processed/manifest.json
```

Ademas carga en PostgreSQL:

```text
knowledge_documents  documentos procesados
knowledge_chunks     chunks vectorizados
medicines            medicamentos estructurados extraidos desde PDFs
```

Para ejecutar la ingesta:

```powershell
docker compose exec backend python scripts/ingest_knowledge_sources.py
```

Ese comando tambien carga los chunks, medicamentos estructurados y embeddings a PostgreSQL + pgvector.
