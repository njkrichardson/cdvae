# Crystal Diffusion Variational AutoEncoder (CDVAE) 

This is a fork of [Crystal Diffusion Variational AutoEncoder (CDVAE)](https://github.com/txie-93/cdvae), which is a research package for generative modeling of (crystalline) materials. Please see their README for additional information on the package functionality and origin. 

This repository came about in an attempt to reproduce the work of Xie et al. using their source code (linked above). The provided miniconda configuration proved broken, and some updates were required to render the code usable with newer versions of PyTorch. This repository contains resources to run the CDVAE code in a repeatable manner on most modern setups (e.g., CUDA major versions 10, 11, and 12) within a container environment. 

## Installation 

First clone the repository and change directory into the project-level directory for the following instructions. 

**Note**: CDVAE expects the data to reside in the `data/` directory directly under the project-level directory. You may collect the data yourself or run `make download` to pull the data down from the original repository. 

### Docker (Recommended) 

The provided Dockerfile utilizes an Nvidia-provided container base image with support for CUDA 11.6. If you'd like to use a different CUDA major/minor version, update the [base image identifier](https://github.com/njkrichardson/cdvae/blob/e34cfb4540c514148ef55083c558d111adedd345/Dockerfile#L3). Since many users coming with a material-science background are not familiar with Docker, we've provided 
a Makefile with reasonable default functions for building/running the image. 

The Docker [documentation](https://docs.docker.com/reference/) is excellent, and can also be consulted for troubleshooting. 

```bash
$ make
...
$ make run
...
$ docker exec -it cdvae /bin/zsh
```

We use miniconda within the container environment (we realize this is insane, but we have not found another way to instantiate a workable dependency collection otherwise). The first time using the container, you'll 
need to run the following: 

```bash 
(container) $ conda init zsh
...
(container) $ zsh
...
(container) (base) $ 
```

Now simply activate the (intra-container) miniconda environment. 

```bash
(container) (base) $ conda activate cdvae
(container) (cdvae) $ python3 cdvae/run.py data=perov expname=perov
```

### Miniconda3

```bash
$ conda create --name cdvae python=3.9 \
    && conda activate cdvae \
    && conda install -y pytorch==1.13.0 torchvision==0.14.0 torchaudio==0.13.0 pytorch-cuda=11.6 -c pytorch -c nvidia \
    && conda install -c conda-forge pytorch-lightning \
    && conda install -c conda-forge ase autopep8 seaborn tqdm nglview \
    && pip install torch_geometric pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-1.13.0+cu116.html \
    && pip install higher hydra-core==1.1.0 hydra-joblib-launcher==1.1.5 p-tqdm==1.3.3 pytest python-dotenv smact==2.2.1 streamlit==0.79.0 torchdiffeq wandb \
    && pip install matminer==0.7.3 \
    && pip install "protobuf==3.20.*"
```
