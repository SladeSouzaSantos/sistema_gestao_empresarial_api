FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# Primeiro atualizamos o pip e instalamos as ferramentas de build
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Tentamos instalar as dependências
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# COMENTE a linha abaixo temporariamente se o build continuar falhando
# RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2"] 
# Reduzi para 2 workers para economizar RAM no Raspberry