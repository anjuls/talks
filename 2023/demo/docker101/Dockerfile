FROM ubuntu
WORKDIR /app
ADD hello.c hello.c
RUN apt update -y && apt install -y gcc
RUN gcc -o hello hello.c
CMD "./hello"