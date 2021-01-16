FROM debian:buster

# ARG USERNAME=user
# ARG USERPASS=pass

# # User setup
# RUN apt-get update && \
#     apt-get install -y sudo && \
#     useradd -m $USERNAME && echo "$USERNAME:$USERPASS" | chpasswd && \
#     echo $USERNAME ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers
    # adduser $USERNAME sudo

# USER $USERNAME

# Set the locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

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

COPY aliases /root/.aliases
COPY p10k.zsh /root/.p10k.zsh
COPY zshrc /root/.zshrc

COPY default_init.vim /root/.config/nvim/init.vim
RUN vim +PlugInstall +qall

WORKDIR /root/workspace

VOLUME ["/var/run/docker.sock", "/root/.custom_profile", "/root/workspace", "/root/.ssh", "/root/.config/git"]

ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]
# CMD bash -c "while true; do echo 'Hit CTRL+C'; sleep 1; done"
