#!/bin/sh
set -e

ZSH_THEME=powerlevel10k/powerlevel10k
ZSH_PLUGINS=""
ZSHRC_APPEND=""

while getopts ":t:p:a:" opt; do
    case ${opt} in
        t)  THEME=$OPTARG
            ;;
        p)  PLUGINS="${PLUGINS}$OPTARG "
            ;;
        a)  ZSHRC_APPEND="$ZSHRC_APPEND\n$OPTARG"
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            ;;
        :)
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
    esac
done
shift $((OPTIND -1))

echo
echo "Installing dependencies and Oh-My-Zsh with:"
echo "  THEME   = ${ZSH_THEME}"
echo "  PLUGINS = ${ZSH_PLUGINS}"
echo

check_dist() {
    (
        . /etc/os-release
        echo $ID
    )
}

check_version() {
    (
        . /etc/os-release
        echo $VERSION_ID
    )
}

install_dependencies() {
    apt-get update
    apt-get -y install git curl wget zsh locales vim xclip
    locale-gen en_US.UTF-8

    # Docker and docker-compose installation
    curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar xvz -C /tmp/ && mv /tmp/docker/docker /usr/bin/docker
    curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

zshrc_template() {
    _HOME=$1; 
    _THEME=$2; shift; shift
    _PLUGINS=$*;

    cat <<EOM
# export LANG='es_ES.UTF-8'
# export LANGUAGE='es_ES:es'
# export LC_ALL='es_ES.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export TERM=xterm
##### Zsh/Oh-my-Zsh Configuration
export ZSH="$_HOME/.oh-my-zsh"
ZSH_THEME="${_THEME}"
plugins=($_PLUGINS)
EOM
    printf "$ZSHRC_APPEND"
    printf "\nsource \$ZSH/oh-my-zsh.sh\n"
}

powerline10k_config() {
    cat <<EOM
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_CROSS=true
EOM
}

cd /tmp
install_dependencies

# Install On-My-Zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

# Generate plugin list
plugin_list=""
for plugin in ${ZSH_PLUGINS}; do
    if [ "`echo $plugin | grep -E '^http.*'`" != "" ]; then
        plugin_name=`basename $plugin`
        git clone $plugin $HOME/.oh-my-zsh/custom/plugins/$plugin_name
    else
        plugin_name=$plugin
    fi
    plugin_list="${plugin_list}$plugin_name "
done

# Handle themes
if [ "`echo ${ZSH_THEME} | grep -E '^http.*'`" != "" ]; then
    theme_repo=`basename ${ZSH_THEME}`
    THEME_DIR="$HOME/.oh-my-zsh/custom/themes/$theme_repo"
    git clone ${ZSH_THEME} $THEME_DIR
    theme_name=`cd $THEME_DIR; ls *.zsh-theme | head -1` 
    theme_name="${theme_name%.zsh-theme}"
    THEME="$theme_repo/$theme_name"
fi

# Generate .zshrc
zshrc_template "$HOME" "${ZSH_THEME}" "$plugin_list" > $HOME/.zshrc

# Install powerlevel10k if no other theme was specified
if [ "${ZSH_THEME}" = "powerlevel10k/powerlevel10k" ]; then
    git clone https://github.com/romkatv/powerlevel10k $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    powerline10k_config >> $HOME/.zshrc
fi

# Clean up
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*
