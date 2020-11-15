FROM debian:buster

RUN apt update && \
apt install -y zsh vim git wget curl && \
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

SHELL ["zsh"]

COPY .vimrc /root/.vimrc
COPY wombat.vim /root//.vim/colors/wombat.vim

CMD bash -c "while true; do echo 'Hit CTRL+C'; sleep 1; done"