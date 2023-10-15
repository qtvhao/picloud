FROM debian:12
RUN apt update && apt install curl netcat iputils-ping ssh -y
RUN curl https://raw.githubusercontent.com/qtvhao/picloud/main/pic -o pic && chmod +x pic
