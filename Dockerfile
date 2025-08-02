FROM nvcr.io/nvidia/pytorch:24.12-py3 AS build-stage

# ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse" > /etc/apt/sources.list \ 
    && echo "deb-src https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse" >> /etc/apt/sources.list \ 
    && echo "deb https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse" >> /etc/apt/sources.list  \
    && echo "deb-src https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list


# HomeBrew install
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install -y -q --allow-unauthenticated --no-install-recommends \
    git sudo apt-utils pkg-config build-essential locales ca-certificates zsh

RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
RUN brew install axel the_silver_searcher gawk \
    ctags cscope idutils graphviz \
    tree tig vim neovim htop tmux ffmpeg wget curl fzf jq \
    ripgrep gdu bottom lazygit \
    starship

USER root
RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew

# locales
RUN locale-gen "en_US.UTF-8" 
RUN update-locale
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_TYPE=en_US.UTF-8

# Pypi
WORKDIR /root

# Oh-my-zsh & Spaceship theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_DIR_TRUNC="0"' \
    -a 'SPACESHIP_DIR_TRUNC_REPO="false"' \
    -a 'SPACESHIP_VI_MODE_SHOW="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/conda-incubator/conda-zsh-completion \
    -p https://github.com/zsh-users/zsh-syntax-highlighting.git

RUN ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

# Tmux
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .

# AstroNvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
# RUN nvim --headless -c "autocmd User LazySync quitall" -c "Lazy sync"

#
RUN echo "eval \"$(starship init zsh)\"" >> /root/.zshrc

# Env
RUN echo "exec zsh" >> /root/.bash_profile

# FROM alpine:latest AS final-stage
# WORKDIR /
# COPY --from=build-stage / /

CMD ["bash", "-l"]
