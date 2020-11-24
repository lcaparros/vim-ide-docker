# vim-ide-docker
Here the final VIM based dockerized IDE. It includes everything to make it a complete IDE experience from the CLI.

## Run vim-ide docker container
Firstly, download **vim-ide** image:
```
docker pull lcaparros/vim-ide
```

**vim-ide** docker image requires to bind-mount the docker socket from the host machine to the docker container. It is necessary to manage docker containers from **vim-ide** instance. It gives an oportunity to run and debug applications from host and **vim-ide** container. Depending on the host OS where Docker engine is executed you could need to type a different command to run it properly.

In adittion, the workspace directory can be shared between host and **vim-ide** container. In the example commands below workspace is specified as a shared volume and ports from 4000 to 4100 are exposed to enable them to development purpose, but just to clarify, it is not mandatory.

### Linux and Mac environment
```
docker run -it --rm --name vim-ide -e "TERM=xterm-256color" -v /var/run/docker.sock:/var/run/docker.sock -v /home/user/workspace:/root/workspace -p "4000-4100:4000-4100" lcaparros/vim-ide
```

### Windows environment
Windows hosts do not count on **/var/run/docker.sock**. In this case Docke use a Virtual Machine with Linux to run Docker engine. So it is necessary to indicate the VM path, if available, instead of **/var/run/docker.sock**. If you are using Docker Desktop, it is recommended to enable WSL2 integration instead of HyperV or Windows container management. Please find more info about how to enable it [here](https://docs.microsoft.com/es-es/windows/wsl/install-win10).

Imagine a Windows host with Debian Linux distribution running over WSL2 and with Docker installed<sup>[1](#debianWSL2DockerDesktop)</sup><sup>[2](#debianWSL2DockerLinux)</sup><sup>[3](#debianUserDocker)</sup>. In this case, the command below would work perfect.

```
docker run -it --rm --name vim-ide -e "TERM=xterm-256color" -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/c/Users/user/workspace:/root/workspace -p "4000-4100:4000-4100" lcaparros/vim-ide
```

### Customiozed terminal interface
Those images includes ZSH with Powerlevel10k theme by default with a configuration that includes an insane quantity of icons and characters. To assure a complete compatibility install Nerd Fonts and setup in your terminal emulator.

* [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
* [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
* [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
* [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

You can also modify p10k.zsh and zshrc files as desired with you own configuration.

## Basic VIM command list
### Text deletion
* x – Remove the selected character
* dd – Remove the complete line
* D – Remove from the cursor location to the end of the line

### Copy and paste
* y – Copy
* yy – Copy the complete line
* Y – Copy from the cursor location to the end of the line
* p – Paste just under the curent line
* P – Paste at the end of the line

### Handling documents and files
VIM allows files management via command line. To work with a file in VIM, the command must start with **:**
* : q – Salir de Vim. Si los cambios no se guardan, se perderán.
* : q! – Salir de Vim. Ignora los cambios no guardados.
* : w – Guardar cambios. Si queremos guardar con un nombre o ubicación distinta, agregaremos un espacio y un nombre de archivo.
* :wq! – Guardar y salir. Guardaremos el fichero con el nombre actual y cerraremos Vim.

<br />
<br />
<br />
<br />
<br />
<hr />

<a name="debianWSL2DockerDesktop">1</a>: The easiest way to setup Docker engine in your Debian WSL2 distribuion will be using **Docker Desktop for Windows**.

Once you have installed **Docker Desktop for Windows**, navigate to **Resources** within **Settings** panel. Now enable the integration with the desired distro into **WSL Integration** option. Remind you must be using **Docker Desktop** with WSL2 containers instead of Windows or HyperV ones.


<a name="debianWSL2DockerLinux">2</a>: To setup Debian Linux distribution running docker and docker compose you can execute [package.sh](https://github.com/lcaparros/vim-ide-docker/blob/main/packages.sh) script using sudo to install all the necessary dependencies. Possibly Docker will not start running. To make it run type:

```
$ sudo service docker start
```

If you get an error related with **IPTALES** it can be due to Debian in its latest vesions is using the new **nftables** firewall. To make Debian use the legacy **IPTABLES** type:

```
$ sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
$ sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

**dockerd** should start fine after switching to iptables-legacy.


<a name="debianUserDocker">3</a>: You will need to use sudo to run docker. To avoid it you can add the user to docker group.

```
$ sudo gpasswd -a $USER docker
```

Note that the docker group grants privileges equivalent to the root user. For details on how this impacts security in your system, see [Docker Daemon Attack Surface](https://docs.docker.com/engine/security/#docker-daemon-attack-surface).
