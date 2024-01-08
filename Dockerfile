# syntax=docker/dockerfile:1

FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04
LABEL maintainer="njkrichardson@princeton.edu" 

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ARG CONDA_ARCH="x86_64" 

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    build-essential \
    gdb \
    zsh \
    direnv \
    wget \
    curl \
    git \
    ninja-build \
    libopenblas-dev \
    gettext \
    cmake \
    unzip \
    parallel \ 
    npm \
    python3-venv \
    python3-pip \
    python3-dev \
    vim 

# conda configuration 
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${CONDA_ARCH}.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-${CONDA_ARCH}.sh -b \
    && rm -f Miniconda3-latest-Linux-${CONDA_ARCH}.sh
RUN conda init zsh \
    && . ~/.zshrc \
    && conda create --name cdvae python=3.9 \
    && conda activate cdvae \
    && conda install -y pytorch==1.13.0 torchvision==0.14.0 torchaudio==0.13.0 pytorch-cuda=11.6 -c pytorch -c nvidia \
    && conda install -c conda-forge pytorch-lightning \
    && conda install -c conda-forge ase autopep8 seaborn tqdm nglview \
    && pip install torch_geometric pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-1.13.0+cu116.html \
    && pip install higher hydra-core==1.1.0 hydra-joblib-launcher==1.1.5 p-tqdm==1.3.3 pytest python-dotenv smact==2.2.1 streamlit==0.79.0 torchdiffeq wandb \
    && pip install matminer==0.7.3 \
    && pip install "protobuf==3.20.*"

# configure zsh 
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t af-magic \
    -p git \
    -p vi-mode 

RUN cd / && git clone https://github.com/njkrichardson/dots.git && parallel cp dots/.zshrc ::: /.zshrc ~/.zshrc && echo "export XDG_CONFIG_HOME=/.config" >> /.zshrc && echo "export XDG_CONFIG_HOME=/.config" >> ~/.zshrc

# configure neovim 
#RUN git clone https://github.com/neovim/neovim && cd neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install 
#RUN mkdir /.config && cd / && git clone https://github.com/njkrichardson/nvimconfig.git && cp -r nvimconfig /.config/nvim 
#RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

CMD ["/bin/zsh"]
