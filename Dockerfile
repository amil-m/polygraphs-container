FROM python:3.12-slim

WORKDIR /app

# Install system dependencies for DGL
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# Install CPU PyTorch
RUN pip --no-cache-dir install torch==2.2.0 --index-url https://download.pytorch.org/whl/cpu

# Torchdata Pydantic Setuptools
RUN pip --no-cache-dir install torchdata==0.7.1 pydantic packaging setuptools wheel

# Other packages for polygraphs
RUN pip --no-cache-dir install pandas PyYaml h5py fsspec numpy==1.26.4 matplotlib

# Jupyterlab
RUN pip --no-cache-dir install jupyter-ruff jupyterlab ipywidgets seaborn
# This port will be used in entrypoint.sh for jupyter lab
EXPOSE 8888

# Install DGL
RUN pip --no-cache-dir install dgl==2.1.0 -f https://data.dgl.ai/wheels/torch-2.2/repo.html

# Set DGL to use PyTorch
RUN python -m dgl.backend.set_default_backend . pytorch

# Clone and install Polygraphs
RUN git clone https://github.com/alexandroskoliousis/polygraphs.git && \
    cd polygraphs && \
    pip install --no-cache-dir .

# Set environment variable of location to save sims
ENV POLYGRAPHS_CACHE=/app/polygraphs-cache

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "/app/polygraphs/run.py"]
