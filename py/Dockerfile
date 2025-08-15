FROM python:3.11-slim

WORKDIR /app

# Instalar dependências do sistema (se necessário)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# Usuário não-root (opcional)
RUN useradd -m appuser
USER appuser

ENV FLASK_RUN_HOST=0.0.0.0
CMD ["python", "app.py"]
