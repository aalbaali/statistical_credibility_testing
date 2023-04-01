# Development container

Development container that can be used with VSCode.

It works on Linux, Windows and OSX.

## Requirements

- [VS code](https://code.visualstudio.com/download) installed
- [VS code remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed
- [Docker](https://www.docker.com/products/docker-desktop) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) installed

## Setup

1. Create the following files on your host if you don't have them:

    ```sh
    touch ~/.gitconfig ~/.zsh_history
    ```

    Note that the development container will create the empty directories `~/.docker` and `~/.ssh` if you don't have them.

1. **For Docker on OSX or Windows without WSL**: ensure your home directory `~` is accessible by Docker.
1. **For Docker on Windows without WSL:** if you want to use SSH keys, bind mount your host `~/.ssh` to `/tmp/.ssh` instead of `~/.ssh` by changing the `volumes` section in the [docker-compose.yml](docker-compose.yml).
1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P).
1. Select `Remote-Containers: Open Folder in Container...` and choose the project directory.

## Customization

### Customize the image

You can make changes to the [Dockerfile](Dockerfile) and then rebuild the image. For example, your Dockerfile could be:

```Dockerfile
FROM qmcgaw/latexdevcontainer
RUN apk add curl
```

To rebuild the image, either:

- With VSCode through the command palette, select `Remote-Containers: Rebuild and reopen in container`
- With a terminal, go to this directory and `docker-compose build`

### Customize VS code settings

You can customize **settings** and **extensions** in the [devcontainer.json](devcontainer.json) definition file.

### Entrypoint script

You can bind mount a shell script to `/home/vscode/.welcome.sh` to replace the [current welcome script](shell/.welcome.sh).

### Publish a port

To access a port from your host to your development container, publish a port in [docker-compose.yml](docker-compose.yml). You can also now do it directly with VSCode without restarting the container.

### Run other services

1. Modify [docker-compose.yml](docker-compose.yml) to launch other services at the same time as this development container, such as a test database:

    ```yml
      database:
        image: postgres
        restart: always
        environment:
          POSTGRES_PASSWORD: password
    ```

1. In [devcontainer.json](devcontainer.json), change the line `"runServices": ["vscode"],` to `"runServices": ["vscode", "database"],`.
1. In the VS code command palette, rebuild the container.

# Building LaTeX
## Source directories
- Store the `.tex` directories in `src/`
- Name the main file as `main.tex`. Note that it's possible to rename the generated PDF file by [passing a variable to the `Makefile`](#renaming-the-main-target).
- The main file may `\include{}` other `.tex` files within `src/`

An example is provided in the `src/` file.

## Makefile
A `Makefile` is provided for building the latex file.

### Default build
Running
```bash
make
```
will
- generate a `build/main.*` files, including `main.pdf`
- `main.pdf` will be copied to the workspace root directory

### Renaming the main target
The main target is named `main` by default. This can be renamed by passing a `JOBNAME` to the `Makefile`. That is,
```bash
make JOBNAME=mytarget
```
will rename the targets to `mytarget.*` including the PDF file copied to the workspace root directory.

### Clean
The `Makefile` has a `clean` target that deletes `build/` but keeps the main PDF file in the main root direcotry.
To clean the directory, run
```bash
make clean
```