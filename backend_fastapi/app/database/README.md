# Database

El backend usa PostgreSQL con la extension `pgvector`.

Al iniciar la API se ejecuta:

1. Creacion de la extension `vector`.
2. Creacion de tablas si no existen.
3. Seed inicial de fuentes y relaciones semanticas cuando las tablas estan vacias.

Las tablas documentales principales son `knowledge_documents` y `knowledge_chunks`.
