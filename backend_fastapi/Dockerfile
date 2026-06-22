FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY backend_fastapi/requirements.txt /app/backend_fastapi/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /app/backend_fastapi/requirements.txt

COPY backend_fastapi /app/backend_fastapi
COPY base_conocimiento /app/base_conocimiento

WORKDIR /app/backend_fastapi

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
