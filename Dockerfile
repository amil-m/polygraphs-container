FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install all Python dependencies in fewer layers
RUN pip install --upgrade pip && \
    pip install --no-cache-dir torch==2.2.0 --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir \
    torchdata==0.7.1 \
    pydantic \
    packaging \
    setuptools \
    wheel \
    pandas \
    PyYaml \
    h5py \
    fsspec \
    numpy==1.26.4 \
    matplotlib \
    jupyter-ruff \
    jupyterlab \
    ipywidgets \
    seaborn && \
    pip install --no-cache-dir dgl==2.1.0 -f https://data.dgl.ai/wheels/torch-2.2/repo.html

# Configure DGL backend
RUN python -m dgl.backend.set_default_backend . pytorch

# Clone and install Polygraphs
RUN git clone https://github.com/alexandroskoliousis/polygraphs.git && \
    pip install --no-cache-dir ./polygraphs

ENV POLYGRAPHS_CACHE=/app/polygraphs-cache
EXPOSE 8888

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "/app/polygraphs/run.py"]
