Install [container](https://github.com/apple/container) if you are running on a Apple Silicon processor, otherwise install [podman](https://podman.io) for your platform. Replace the `container` command with `podman` in the instructions below if using podman.

The `Dockerfile` contains installation commands for all required packages for Polygraphs. Jupyter, pandas, and seaborn are installed inside the container, if you need any other packages on a permanent basis, it might be worth adding the package to the installation script inside `Dockerfile`, otherwise you can install temporarily using the termninal inside Jupyter Lab via `pip`.

## Build Instructions
Start container service

```bash
container system start
```
Build the container using the Dockerfile and call it polygraphs.

```bash
container build --tag polygraphs .
```

Call the container with:

```bash
container run polygraphs
```

### GPU Containers
For GPU support, it will be better to create another contianer based on these images.
- [nvidia GPU containers using DGL/CUDA](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/dgl?version=25.08-py3)
- [AMD GPU containers using DGL/ROCM](https://hub.docker.com/r/rocm/dgl)

## Using the Container
Running JupyterLab inside the container:

```bash
container run -p 8888:8888 polygraphs jupyter
```

Jupyter Lab loads from the `/app` directory in the container, all simulations are stored in `/app/polygraphs-cache` by default.

If you want to load a directory of results to analyse located on the host, you can mount one as a volume using:

```bash
container run \
    -p 8888:8888 \
    -v $(pwd)/results:/app/results \
    polygraphs jupyter
```

This command load a directory named `results` inside the container as `/app/results`. Windows users should use `{PWD}` instead of `$(pwd)` for current directory.

### Simulation Configuration
- Below, a config file located in the host at `config/test.yaml` is used for the simulation
- Outputs are sent to a host directory called `polygraphs-cache`

```bash
container run \
    -v $(pwd)/configs:/configs \
    -v $(pwd)/polygraphs-cache:/app/polygraphs-cache \
    polygraphs run -f /configs/test.yaml
```

## Development
For development mounting the `app` directory as a volume on the host, the host directory should contain a clone of the polygraphs repo.

```bash
container run \
    -v $(pwd):/app \
    polygraphs run -f /configs/test.yaml
```

or

```bash
container run \
    -p 8888:8888 \
    -v $(pwd):/app \
    polygraphs jupyter
```
