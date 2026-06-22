# Database

El backend usa PostgreSQL con la extension `pgvector`.

Al iniciar la API se ejecuta:

1. Creacion de la extension `vector`.
2. Creacion de tablas si no existen.
3. Seed inicial desde `base_conocimiento/data/medicamentos.json` cuando la tabla esta vacia.

La tabla principal es `medicines`.
