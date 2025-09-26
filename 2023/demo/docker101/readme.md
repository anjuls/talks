# docker image build


## Docker with ubuntu as base OS

```
FROM ubuntu
WORKDIR /app
ADD hello.c hello.c
RUN apt update -y && apt install -y gcc
RUN gcc -o hello hello.c
CMD "./hello"
```
Let's build the image and see.

```
docker build . -t hello:ubuntu
docker run hello:ubuntu
Hello, World!

> docker container is terminated

docker ps -a
CONTAINER ID   IMAGE                  COMMAND                    CREATED         STATUS                     PORTS                       NAMES
b9325e259df2   hello:ubuntu           "/bin/sh -c \"./hello\""   9 seconds ago   Exited (0) 7 seconds ago                               unruffled_mendel
0ff5cc181a0e   hello:ubuntu           "/bin/sh -c \"./hello\""   7 minutes ago   Exited (0) 7 minutes ago                               quizzical_mestorf


docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
hello          ubuntu    0b7389031108   43 seconds ago   409MB
```

# Docker multi-stage build


```
docker build . -f Dockerfile.multistage -t hello:scratch

docker run hello:scratch
Hello, World!

docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
hello          scratch   56367a017c7c   21 minutes ago   976kB        ---> previously it was 409MB with Ubuntu 
```

# Docker build for different machine architecture

```
docker buildx build .  --platform=linux/amd64,linux/arm64,linux/arm/v7 -t hello:platformdemo -f Dockerfile.multistage

docker images -a
REPOSITORY     TAG            IMAGE ID       CREATED          SIZE
hello          platformdemo   9f33c4c8e373   50 seconds ago   382kB
hello          platformdemo   9f33c4c8e373   50 seconds ago   976kB
hello          platformdemo   9f33c4c8e373   50 seconds ago   264kB

```

# Docker commands

## interacting with registry

```
docker tag hello:scratch anjuls/hello:scratch
```

### Pushing to Docker registry.

```
docker push anjuls/hello:scratch
The push refers to repository [docker.io/anjuls/hello]
205d8eac262a: Pushed
fc0804ca3b7c: Pushed
0604ea51b470: Pushed
56367a017c7c: Pushed
dd8e21e03495: Pushed
038ddb65adaf: Pushed
3116e1d09da5: Pushed
44f4b8cd43a2: Pushed
scratch: digest: sha256:56367a017c7c7db74c4d26b929a7071d866b16f8a4bd0a07bcdb5e512bf0df6d size: 855
```

### Pulling from Docker regitry

```
docker pull anjuls/hello:scratch
scratch: Pulling from anjuls/hello
Digest: sha256:56367a017c7c7db74c4d26b929a7071d866b16f8a4bd0a07bcdb5e512bf0df6d
Status: Image is up to date for anjuls/hello:scratch
docker.io/anjuls/hello:scratch
```

## See Docker Resource Usage and Inspect

```
docker stats
CONTAINER ID   NAME                 CPU %     MEM USAGE / LIMIT     MEM %     NET I/O          BLOCK I/O       PIDS
d55b7e3ac85e   kind-control-plane   32.39%    696.1MiB / 7.667GiB   8.87%     55.6MB / 247MB   221kB / 760MB   317
```

## Limiting cpu and memory resources

cpu in decimal, .01 of 1 cpu
mem is bytes, min 6MB is required for this image.

```
docker run --cpus=0.01 -m=7024000 hello:scratch
Hello, World!
```