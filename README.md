# LaTeX VSCode Workspace Container
<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Usage](#usage)
  * [Building latex files](#building-latex-files)
    * [Makefile](#makefile)
    * [Using Docker](#using-docker)
      * [Developing within the Docker container](#developing-within-the-docker-container)
      * [Build latex using non-interactive container](#build-latex-using-non-interactive-container)
    * [Visual Studio Code](#visual-studio-code)
    * [Running Github Actions locally](#running-github-actions-locally)
* [Github Actions](#github-actions)

<!-- vim-markdown-toc -->

# Overview

This is a Github template for developing and building latex files from within a Docker container.
The repo has the following features:
- Dockerfile for building latex files
- The Dockerfile contains custom latex packages/classes from [aalbaali/latex_classes](https://github.com/aalbaali/latex_classes)
- The code was originally forked from [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer) but it heavily deviated from it
- The repo has `.devcontainer` folder for easier development from within VSCode
- Github actions that build the latex files on the cloud
- Upload pdf files to the wiki

# Usage
- This is a Github template, so it can be used to create a new repo.
- Write `.tex` files in the `src` directory.
- Build the latex files using one of the options below.
- When forking the repo, ensure that the *Allow all actions and reusable workflows* option is enabled in the forked repo.

## Building latex files
There are various ways to build the latex images:
- They can be built on the host machine if latexmk is installed;
- They can be built using Docker containers non-interactively;
- Or they can even be built in a Docker container throughout writing the latex files.

The various options are presented below

### Makefile
The latex files can be built using the `latexmk` commands, which takes various arguments.
To simplify it for the user, some of these commands are stored in [`Makefile`](Makefile), which can be called running `make` from the root of this repo.
The default Make targets will generate the build files in a `build` directory and will copy the pdf file to the root directory and will be renamed to be the directory's basename.

Note that building the latex files using `Make` will only work if `latexmk` is installed including the possibly custom packages used in the `.tex` source files.
Thus, there are two ways to use the Makefile:
1. if `make` and `latexkmk` are installed on the host machine with all required (custom) latex packages/classes, then the Makefile can be used directly;
2. running the Makefile from a Docker container that has `latexmk` installed with all other required packages (more on this below).

### Using Docker
It's possible to build the latex files in a latex container without running it on your host machine.
The only requirement is to have Docker installed.
Some of the advantages of using a Docker container is portability and consistency across all platforms.

Before using the Docker container, the Docker image needs to be built, which can be done by running
```bash
docker build -f Dockerfile -t latex_dev_image  .
```
from the repo's root, where `latex_dev_image` is the image name, which can be renamed (stay consistent with the next step).
Note that the Docker image needs to be built once (unless the [`Dockerfile`](.devcontainer/Dockerfile) changes).

Once the Docker image is built, the Docker containers can then be started and used to build the latex files.
There are generally two ways to do this:
1. develop within the container;
2. build the latex files non-interactively

#### Developing within the Docker container
Running the Docker container interactively will allow you to develop (i.e., write files and build latex files) from within the container.
To run the container, run (from the repo's root)
```bash
docker run --rm -it -v $PWD:/home/latex/simple_tex -w=/home/latex/simple_tex  latex_dev_image
```
Since `make` and `latexmk` are both installed in the Docker container, then it's possible to use the `Makefil` by running
```bash
$ make
```
from the repo's root.

Some notes about the built files:
- The built files will be visible from the host machine since the directory is mounted using the `-v ...` flag.
However, other changes outside this directory (from either host or the container) will not be visible from the host machine.

- The files built from within this container are built using `root` user. Thus, eleveated privileges are required to modify these files from *host*, including deleting them. This can be done by prepending the commands with `sudo`.

#### Build latex using non-interactive container
It's possible to build the latex files without going inside the container by running
```bash
docker run --rm -v $PWD:/home/latex/simple_tex -w=/home/latex/simple_tex  --user latex latex_dev_image  make
```
The command above calls `make` from within the container, which will build the latex files.
The files will be visible by the host machine since the directory is mounted to the container.

### Visual Studio Code
Visual Studio Code has useful features to interact with Docker images and containers.
[This page](https://code.visualstudio.com/docs/remote/containers) outlines how VSCode interacts with Dockerfiles.

To use VSCode with the Dockerfile, simply run VSCode from the root of this directory, then VSCode will prompt the user to run the code from within the container.
If this option is chosen, then VSCode will build the Docker image and run the files from within the container.
This is possibly the most convenient option.

Some notes about building the latex files using VSCode:
- VSCode will *not* use the Makefile in this directory. Thus, the `latexmk` command may be called differently in VSCode than when calling `make`
- The default `build` shortcut is `ctrl + shift + b`

### Running Github Actions locally
There are two [Github actions](#github-actions) in this repo that ensure the pushed latex files are building and catches any errors the user might've missed.

The Github action can be run locally using the [nektos/act](https://github.com/nektos/act) packages, which has two main advantages:
1. allows for debugging the Github action;
2. build the latex files locally using the Github actions.
Buildling the files locally will ensure that whatever is built locally will also be built on the Github servers, which reduces mismatches between the local and on-cloud builds.

For example, to run the `latex-action` action, run
```bash
act -a latex-action
```

# Github Actions
The repository has two continuous integration Github actions to build the latex code:
- `latex-action`: builds latex files by running [aalbaali/latex-action](https://github.com/aalbaali/latex-action);
- `latex-local`: builds latex files using the local [Dockerfile](.devcontainer/Dockerfile).

The `latex-local` pipeline is mainly for testing the files the same way they were developed locally, whereas the `latex-action` uses another Github action to build the files.
The `latex-action` enforces consistency across different latex repositories.

# Wiki
Whenever pushing the code to any branch, the PDF is built and uploaded to the [Wiki pages](https://github.com/aalbaali/latex_dev_container/wiki).
The PDFs are versioned using symantic versioning as per the [github-tag-action](https://github.com/mathieudutour/github-tag-action#bumping).

When pushing to the `main` or `release/*` branches, two things happen:
1. a tag is created for that build, and
2. the PDF version is bumped as per [github-tag-action bump policy](https://github.com/mathieudutour/github-tag-action#bumping).
The PDF releases are stored under the [releases page](https://github.com/aalbaali/latex_dev_container/wiki/Releases) and latest page is kept under the [home page](https://github.com/aalbaali/latex_dev_container/wiki).
