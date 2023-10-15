FROM debian:11
RUN apt update && apt install curl netcat iputils-ping -y
