# Usa la stessa versione Python che abbiamo visto nei log (3.10)
FROM python:3.10-bookworm

# 1. Installa dipendenze di sistema
# libgl1-mesa-glx serve per OpenCV (spesso usato in anomalib)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0

# 2. Installa uv (molto più veloce di pip)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# 3. Imposta la cartella di lavoro
WORKDIR /app

# 4. Copia tutto il progetto dentro il container
COPY . .

# 5. Installa le dipendenze del progetto usando uv
# --system installa nel Python globale del container (ideale per Docker)
RUN uv pip install --system .

# Se hai dipendenze extra per i test, installale qui (es. pytest)
RUN uv pip install --system pytest tox

# 6. Comando di default: lancia i test
CMD ["pytest tests/unit/cli/test_help_formatter.py::TestCustomHelpFormatter::test_verbose_1"]
