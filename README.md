# python3-docker-devenv

This repository is for a developer who writes python3 codes on ubuntu
in docker container.

## Development Environment Version Details
* Ubuntu: 18.04.1 LTS
* Python: 3.*

## Requirements

* Docker is installed on your machine where you run following commands.  

If not, you need to install Docker first.
> https://www.docker.com/get-started

## Usage
Firstly, you need to clone this repository and go into the directory.  
```
$ git clone git@github.com:resotto/python3-docker-devenv.git
$ cd python3-docker-devenv
```
And then, run following docker commands.  
```
$ docker build -t ubuntu-python3:0.0.1 .
$ docker run -it ubuntu-python3:0.0.1 python3 hello.py
Hello python3-docker-devenv!
```
You could specify other value for:
* -t ${NAME:TAG} and ${IMAGE NAME}

If you confirmed *"Hello python3-docker-devenv!"*, congratulation! You can develop
in this container.

In order to save contents in the container, create *data container* first.
```
$ docker run -v /app --name pydata ubuntu:18.04 echo "Data-only container for python3"
```
You could specify other value for:
* --name ${CONTAINER NAME}  

After executing this command, this container stops. However, it is possible for
data container to be stopped.

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
If you want to confirm container status, you can use this command.
```
$ docker ps -a
```
When the container is stopped, you can run commands below.  
At first, you start the container. Then, you run docker exec command in order to
run commands in the container.
```
$ docker start ubuntu-python3
$ docker exec -it ubuntu-python3 /bin/bash
```

After finishing something cool development, you can escape from the container
with *"exit"* command or *"ctrl + d"*.  
You also can run following command, which makes the container stop.
```
$ docker stop ubuntu-python3
```

If you want to remove the container, you can run command below:
```
$ docker rm ubuntu-python3
```

Even after removing the container, docker volume remains. So you can confirm
volume status and remove it by running following commands.
```
$ docker volume ls
$ docker volume rm ${VOLUME NAME}
```

## Optional
### Install python packages
This repository has `requirements.txt`.  
You can add python packages into the file so that
they are installed with pip when you run docker build command.

### Install Vim
Actually, you already have installed vim and this repository also has `.vimrc` which is copied to *"/root"* in the container.

Thus you can use vim by default!  

If you want to use other text editor, you can do same thing like this.
