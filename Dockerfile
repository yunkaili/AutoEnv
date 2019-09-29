FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils pkg-config build-essential locales
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc python3 python3-pip python3-dev python3-setuptools
RUN apt-get update
RUN apt-get install -y --no-install-recommends zsh git wget make automake vim tmux
RUN apt-get update
RUN apt-get install -y --no-install-recommends libjpeg-dev libfreetype6-dev zlib1g-dev
RUN apt-get update
RUN apt-get install -y --no-install-recommends libevent-dev libncurses5-dev libncursesw5-dev cmake-curses-gui
RUN apt-get update
RUN apt-get install -y --no-install-recommends libssl-dev

# RUN git clone https://github.com/yunkaili/AutoEnv

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
CMD zsh
