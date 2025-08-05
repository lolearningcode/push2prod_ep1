# ---------- Base Stage ----------
FROM python:3.11-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ---------- Builder Stage ----------
FROM base AS builder

RUN useradd -m appuser

WORKDIR /app
COPY app/requirements.txt .

# Install Python packages to non-root path
RUN pip install --upgrade pip && \
    pip install --prefix=/home/appuser/.local -r requirements.txt

# ---------- Final Stage ----------
FROM base

RUN useradd -m appuser
USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH

COPY --from=builder /home/appuser/.local /home/appuser/.local
COPY --chown=appuser:appuser app /app

WORKDIR /app
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]