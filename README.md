# vim-ide-docker
Here the final VIM based dockerized IDE. It includes everything to make it a complete IDE experience from the CLI.

## Basic command list
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