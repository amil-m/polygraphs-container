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
Running JupyterLab inside the conainer:

```bash
container run -p 8888:8888 polygraphs jupyter
```

It is useful to have a directory of results to analyse, you can mount one with:

```bash
container run \
    -p 8888:8888 \
    -v $(pwd)/results:/app/results \
    polygraphs jupyter
```


When you want to use a config file where you have a local directory called `config` you should mount that first, then the outputs will be sent to a local directory named `polygraphs-cache`

- Inside my local `config` directory, there is a file called `test.yaml`

```bash
container run \
    -v $(pwd)/configs:/configs \
    -v $(pwd)/polygraphs-cache:/app/polygraphs-cache \
    polygraphs run -f /configs/test.yaml
```

## Development
For development it is worth mounting the `app` directory, it should contain a `polygraphs` directory that is a clone of the repo.

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
