FROM python:3.11-slim

# Instalando dependências de sistema essenciais
RUN apt-get update && apt-get install -y \
    libmariadb-dev-compat \
    pkg-config \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# Upgrade ferramentas de build
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Instalação das dependências
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", 2]