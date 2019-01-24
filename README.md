# python3-docker-devenv

This repository is for a developer who is new to Docker and
wants to write python3 codes on ubuntu in docker container.  
If you finish this tutorial, you will be able to develop with python3 in docker container.

## Table of Contents
* [Version Details](#version-details)
* [Requirements](#requirements)
* [Usage](#usage)
* [How to Use Docker Commands](#how-to-use-docker-commands)
* [How to Configure Dockerfile](#how-to-configure-dockerfile)
* [Optional](#optional)

## Installed Software Version Details
* ubuntu: 18.04.1 LTS
* python: 3.6.7
* git: 2.17.1

## Requirements

[git](https://git-scm.com/downloads) and [Docker](https://www.docker.com/get-started) are installed on your machine where you run following commands.  
If not, you need to install them first.

## Usage
Firstly, you need to clone this repository and go into the directory.  
```
$ git clone git@github.com:resotto/python3-docker-devenv.git
$ cd python3-docker-devenv
```
And then, create image from Dockerfile and start new container from it.  
[`docker build`](https://docs.docker.com/engine/reference/commandline/build/) creates image from Dockerfile.  
[`docker run`](https://docs.docker.com/engine/reference/commandline/run/) starts new container from image.  
Once you complete building image, you don't need to do anymore until Dockerfile is changed.
```
$ docker build -t ubuntu-python3:0.0.1 .
$ docker run -it ubuntu-python3:0.0.1 python3 hello.py
Hello python3-docker-devenv!
```
These commands syntax are below:
* docker build -t ${NAME:TAG} ${Build Context}
* docker run -it ${IMAGE NAME} ${COMMAND}

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
* docker run -v ${VOLUME DIRECTORY} --name ${CONTAINER NAME} ${IMAGE NAME} ${COMMAND}

Specifying `-v ${VOLUME DIRECTORY}` is very important to create Docker Volume.  
If don't, Docker Volume is not created.  
`${VOLUME DIRECTORY}` is just a directory in the container and the files in it are
copied to a Docker Volume.  
Thus, when you develop something cool, you work on this directory in order to save files.

After executing this command, this container stops. However, it is possible for
data container to be stopped and it should be so.

Then, run this command and you will enter the container such as running
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
If you want to confirm container status, you can use [`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/) command. If you
specify `a` option, you can retrieve all containers status, while if not
you retrieve only containers running now.
```
$ docker ps -a
```
If you specify `q` option, it returns container ids so that you can do something
like this when you want to remove all containers.
```
$ docker rm $(docker stop $(docker ps -aq))
```

When the container is stopped, you can run commands below, for the purpose of
resuming it.  
[`docker start ${CONTAINER NAME}`](https://docs.docker.com/engine/reference/commandline/start/) starts the container.  
[`docker exec ${CONTAINER NAME}`](https://docs.docker.com/engine/reference/commandline/exec/) runs commands in the container.
```
$ docker start ubuntu-python3
$ docker exec -it ubuntu-python3 /bin/bash
```

After finishing your cool development, you can escape from the container
with `exit` command or `ctrl + d`.  
You also can run [`docker stop ${CONTAINER NAME}`](https://docs.docker.com/engine/reference/commandline/stop/), which makes the container stop.
```
$ docker stop ubuntu-python3
```

If you want to remove the container, you can run [`docker rm ${CONTAINER NAME}`](https://docs.docker.com/engine/reference/commandline/rm/).
```
$ docker rm ubuntu-python3
```

**Even after removing the container, docker volume remains**. So you can confirm
volume status by running [`docker volume ls`](https://docs.docker.com/engine/reference/commandline/volume_ls/) command and remove it by running [`docker volume rm`](https://docs.docker.com/engine/reference/commandline/volume_rm/) command.
```
$ docker volume ls
$ docker volume rm ${VOLUME NAME}
```

Besides above, there are many Docker commands, so please check [docker](https://docs.docker.com/engine/reference/commandline/docker/).

## How to Configure Dockerfile
### What is Dockerfile?
Dockerfile is just a file which has a series of processes for the purpose of creating Docker Image.
There are some orders in Dockerfile.  
So Let's take a look at them!

### Orders of Dockerfile
[`FROM`](https://docs.docker.com/engine/reference/builder/#from)  
- [`FROM`](https://docs.docker.com/engine/reference/builder/#from) **must be the first order in Dockerfile**.  
This specifies Docker Image with format `IMAGE:TAG`.  
 If `TAG` is omitted, it will be `latest`, but **`latest` cannot be recommended** because the version of the tag may change in the future.


 [`WORKDIR`](https://docs.docker.com/engine/reference/builder/#workdir)
 - This specifies working directory where orders are executed, such as [`COPY`](https://docs.docker.com/engine/reference/builder/#copy) and [`RUN`](https://docs.docker.com/engine/reference/builder/#run) etc...  
 You can also use this many times. Moreover, you can specify relative path.


[`COPY`](https://docs.docker.com/engine/reference/builder/#copy)
- This order copies file from build context to image. The format is `COPY src dest`. You cannot specify `src` which is out of Build Context.

[`RUN`](https://docs.docker.com/engine/reference/builder/#run)
- This order takes one argument which is command, executes it and commit the result.

Besides above, there are many Dockerfile orders, so please check [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

## <a id="optional">Optional</a>
### Install and Configure git
You already have installed git because it is specified in Dockerfile.
For the purpose of using git in container, let's configure it.

#### Set up git
First of all, you should add your name and your email to git config.
```
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```
If you confirm git config parameters, use [git config](https://git-scm.com/docs/git-config) command with list option.
```
$ git config --list
```

#### Set up ssh
When moved home directory, is there `.ssh` directory? If not, make it first.
```
$ cd ~
$ ls -a
$ mkdir .ssh # if there is no .ssh directory
$ cd .ssh
```

And then, generate private key and public key with `ssh-keygen` command.
```
$ ssh-keygen -t rsa
```
Syntax of this command is below:
* ssh-keygen -t ${ALGORITHM}  

If you specify `t` option, you can choose generation algorithm such as RSA or DSA etc…

When you execute this command, it asks you some questions:
##### Enter file in which to save the key(/root/.ssh/id_rsa):
* Specify path including filename where you want to save keys, for example `/root/temp/id_rsa`.
If specified directory doesn't exist, ssh-keygen command fails.  

##### Enter passphrase (empty for o passphrase):  
* Passphrase is a string of characters, which is longer than usual password (minimum five characters but 20 characters preferably).
It is used in an encryption or a decryption of private key.



After generating keys, copy public key strings and register it on GitHub.

Finally, run following command which attempts to ssh to GitHub.
```
$ ssh -T git@github.com
```
If you are asked to continue connecting, answer *yes* and if you specified passphrase type it and press enter. If you didn't create passphrase, it is not required to do so.
```
root@01cb00143067:~/.ssh# ssh -T git@github.com
The authenticity of host 'github.com (192.30.255.113)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.255.113' (RSA) to the list of known hosts.
Enter passphrase for key '/root/.ssh/id_rsa':
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```
Could you confirmed the last message? Fantastic. From now, you can pull your private repository in this container.

It doesn't work? Please check [Testing your SSH connection](https://help.github.com/articles/testing-your-ssh-connection/).

### Install python packages
This repository has `requirements.txt`.  
You can add python packages into the file so that
they are installed with pip when you run [`docker build`](https://docs.docker.com/engine/reference/commandline/build/).

### Install Vim
Actually, you already have installed vim and this repository also has `.vimrc` which is copied to *"/root"* in the container.

Thus you can use vim by default!  

If you want to use other text editor, you can do same thing like this.
