# python3-docker-devenv

This repository is for a developer who is new to Docker and
wants to write python3 codes on ubuntu in docker container.  
If you finish this tutorial, you will be able to develop with python3 in docker container.

![docker-python](https://user-images.githubusercontent.com/19743841/51781628-8a278900-215e-11e9-9290-eb4b4a097023.png)

## Table of Contents
* [Why Python on Docker Container?](#why-python-on-docker-container)
* [Installed Software Version Details](#installed-software-version-details)
* [Prerequisites](#prerequisites)
* [Quick Start](#quick-start)
* [Usage](#usage)
* [How to Use Docker Commands](#how-to-use-docker-commands)
* [How to Configure Dockerfile](#how-to-configure-dockerfile)
* [Optional](#optional)

## Why Python on Docker Container?
You need not to create virtual environments with `venv` because you can handle them respectively as a container.  

## Installed Software Version Details
* ubuntu: 18.04.1 LTS
* python: 3.6.7
* git: 2.17.1

## Prerequisites
* [git](https://git-scm.com/downloads)
* [Docker](https://www.docker.com/get-started)

## Quick Start
Please run only 2 commands below:
```
$ docker run -v /app --name pydata ubuntu:18.04 echo "Data-only container for python3"
$ docker run -it --name ubuntu-python3 --volumes-from pydata resotto/ubuntu-python3:0.0.1
```

## Usage
Firstly, you need to clone this repository and go into the directory.  
```
$ git clone git@github.com:resotto/python3-docker-devenv.git
$ cd python3-docker-devenv
```
Secondly, [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) creates image from Dockerfile and
[`docker run`](https://docs.docker.com/engine/reference/commandline/run/) starts new container from image.
```
$ docker build -t ubuntu-python3:0.0.1 .
$ docker run -it ubuntu-python3:0.0.1 python3 hello.py
Hello python3-docker-devenv!
```
These commands syntax are below:
* [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) -t ${NAME:TAG} ${Build Context}
* [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) -it ${IMAGE NAME} ${COMMAND}

<details><summary>What is Build Context?</summary><div>
Build Context is just a set of local file or directories which can be referenced from [`ADD`](https://docs.docker.com/engine/reference/builder/#add) or [`COPY`](https://docs.docker.com/engine/reference/builder/#copy) in Dockerfile. Usually, it is specified as directory path.  
Build Context is sent to Docker Daemon as part of build process.  
You can specify Dockerfile path in Build Context with [`docker build -f ${PATH}`](https://docs.docker.com/engine/reference/commandline/build/), **but if not, Docker looks for Dockerfile in the root of Build Context**.</div></details><br>

If you confirmed *"Hello python3-docker-devenv!"*, congratulation! You can develop in this container.  

In order to save contents in the container, create Data Container in advance.<br>  

<details><summary>What is Data Container?</summary><div>
Data Container only aims to share data with other containers.
The advantage of creating Data Container is that we can load Docker Volume NameSpace
with `--volumes-from ${DATA CONTAINER NAME}` easily, which is [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command option.</div></details><br>

```
$ docker run -v /app --name pydata ubuntu:18.04 echo "Data-only container for python3"
Data-only container for python3
```
This command syntax is below:
* [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) -v ${VOLUME DIRECTORY} --name ${CONTAINER NAME} ${IMAGE NAME} ${COMMAND}

Specifying `-v ${VOLUME DIRECTORY}` is very important to create Docker Volume. If don't, Docker Volume is not created.  
`${VOLUME DIRECTORY}` is just a directory in the container and the files in it are
copied to a Docker Volume.  
Thus, you work on this directory in order to save files.

After creating Data Container, this container stops. However, it is possible for
it to be stopped and it should be so.

Then, run following command and you will enter the container such as running
ssh command.
```
$ docker run -it --name ubuntu-python3 --volumes-from pydata ubuntu-python3:0.0.1
```
In the container you can also use python interactive interpreter.
```
root@51c45890a7ed:/app# python3
Python 3.6.7 (default, Oct 22 2018, 11:32:17)
[GCC 8.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

## How to Use Docker Commands
If you want to confirm container status, you can use [`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/). If specifying `a` option, you can retrieve all containers status, while retrieving only running containers with no option.
```
$ docker ps -a
```
If you specify `q` option, it returns only container ids, so that you can do something
like this when you want to remove all containers.
```
$ docker rm $(docker stop $(docker ps -aq))
```

You can resume the container which is stopped now.  
[`docker start`](https://docs.docker.com/engine/reference/commandline/start/) starts the container and [`docker exec`](https://docs.docker.com/engine/reference/commandline/exec/) runs commands in the container. Each commands require one argument which is container name.
```
$ docker start ubuntu-python3
$ docker exec -it ubuntu-python3 /bin/bash
```

You can escape from the container with `exit` or `ctrl + d`.  
You also can run [`docker stop`](https://docs.docker.com/engine/reference/commandline/stop/), which requires container name and stops the container.
```
$ docker stop ubuntu-python3
```

You can remove container with [`docker rm`](https://docs.docker.com/engine/reference/commandline/rm/) which is required container name.
```
$ docker rm ubuntu-python3
```

**Even after removing the container, docker volume remains**.  
So you can confirm volume status with [`docker volume ls`](https://docs.docker.com/engine/reference/commandline/volume_ls/) and remove it with [`docker volume rm`](https://docs.docker.com/engine/reference/commandline/volume_rm/).
```
$ docker volume ls
$ docker volume rm ${VOLUME NAME}
```

Besides above, there are many Docker commands, so please check [docker](https://docs.docker.com/engine/reference/commandline/docker/).

## How to Configure Dockerfile
### What is Dockerfile?
Dockerfile is just a file which has a series of processes for the purpose of creating Docker Image.
There are some orders in Dockerfile.  

### Orders of Dockerfile
#### [`FROM`](https://docs.docker.com/engine/reference/builder/#from)  
- [`FROM`](https://docs.docker.com/engine/reference/builder/#from) **must be the first order in Dockerfile**.  
This specifies Docker Image with format `IMAGE:TAG`.  
 If `TAG` is omitted, it will be `latest`, but **`latest` cannot be recommended because the version of the tag may change in the future**.


#### [`WORKDIR`](https://docs.docker.com/engine/reference/builder/#workdir)
 - This specifies working directory where orders are executed, such as [`COPY`](https://docs.docker.com/engine/reference/builder/#copy) and [`RUN`](https://docs.docker.com/engine/reference/builder/#run) etc... You also can specify relative path and use this order many times in Dockerfile.


#### [`COPY`](https://docs.docker.com/engine/reference/builder/#copy)
- This order copies file from build context to image. The format is `COPY src dest`. You cannot specify `src` which is out of Build Context.

#### [`RUN`](https://docs.docker.com/engine/reference/builder/#run)
- This order takes one argument, which is a command, executes it and commit the result.

Besides above, there are many Dockerfile orders, so please check [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

## Optional
### Install and Configure git
You already have installed git because it is specified in Dockerfile.
So, let's configure it.

#### Set up git
First of all, you should add your name and your email to git config.
```
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```
If you confirm git config parameters, use [git config](https://git-scm.com/docs/git-config) with list option.
```
$ git config --list
```

#### Set up ssh
Is there `.ssh` directory in home directory? If not, make it first.
```
$ cd ~
$ ls -a
$ mkdir .ssh # if there is no .ssh directory
$ cd .ssh
```

And then, generate private key and public key with `ssh-keygen`.
```
$ ssh-keygen -t rsa
```
Syntax of this command is below:
* ssh-keygen -t ${ALGORITHM}  

If you specify `t` option, you can specify generation algorithm such as RSA or DSA etc…

When you execute `ssh-keygen`, it asks you some questions:
##### Enter file in which to save the key(/root/.ssh/id_rsa):
* Specify path including filename where you want to save keys, for example `/root/temp/id_rsa`.
If specified directory doesn't exist, ssh-keygen command fails.  

##### Enter passphrase (empty for o passphrase):  
* Passphrase is a string of characters, which is longer than usual password (minimum five characters but 20 characters preferably).
It is used in an encryption or a decryption of private key.

##### Enter same passphrase again:
* Enter the same passphrase as you typed above.

After generating keys, register public key on GitHub.
At first, copy the result of executing command below.
```
$ cat id_rsa.pub
```
And then, register it on Github following instructions.
###### Open your GitHub account settings.
![click-settings](https://user-images.githubusercontent.com/19743841/51783793-7ee65480-2182-11e9-847b-3e54b647fa01.png)

###### Click `SSH and GPG keys`.
![click-ssh-and-gpg-keys](https://user-images.githubusercontent.com/19743841/51783794-7ee65480-2182-11e9-8787-0ad6046b6da9.png)

###### Click `New SSH key`.
![click-new-ssh-key](https://user-images.githubusercontent.com/19743841/51783792-7ee65480-2182-11e9-84b5-11dbfa51ba21.png)

###### Specify title and paste public key strings and click `Add SSH key`.
![click-add-ssh-key](https://user-images.githubusercontent.com/19743841/51783858-b3a6db80-2183-11e9-9c56-21055d61c3d3.png)

Finally, run following command, which attempts to ssh to GitHub.
```
$ ssh -T git@github.com
```
If you are asked to continue connecting, answer *yes* and if you specified passphrase type it and press enter. If you didn't create passphrase, it is not required.
```
root@01cb00143067:~/.ssh# ssh -T git@github.com
The authenticity of host 'github.com (192.30.255.113)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.255.113' (RSA) to the list of known hosts.
Enter passphrase for key '/root/.ssh/id_rsa':
Hi resotto! You've successfully authenticated, but GitHub does not provide shell access.
```
Could you confirm *"Hi username! You've successfully authenticated, but GitHub does not provide shell access."*? Fantastic! From now, you can pull your private repository in this container.

It doesn't work? Please check [Testing your SSH connection](https://help.github.com/articles/testing-your-ssh-connection/).

### Install python packages
This repository has `requirements.txt` so you can add python packages into it.  
They are installed with pip when you run [`docker build`](https://docs.docker.com/engine/reference/commandline/build/).

### Install Vim
Actually, you already have installed vim and this repository also has `.vimrc` which is copied to *"/root"* in the container. Thus you can use vim by default!  

If you want to use other text editor, you can do same thing like this.
