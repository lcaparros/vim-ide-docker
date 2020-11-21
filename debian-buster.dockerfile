FROM debian:buster

COPY packages.sh packages.sh
RUN ./packages.sh \
    # -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'
RUN rm packages.sh

COPY .vimrc /root/.vimrc
COPY wombat.vim /root/.vim/colors/wombat.vim

WORKDIR /root/workspace

VOLUME ["/var/run/docker.sock", "/root/workspace"]

ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]
# CMD bash -c "while true; do echo 'Hit CTRL+C'; sleep 1; done"
