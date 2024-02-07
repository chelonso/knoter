FROM alpine:latest

RUN apk add --no-cache bash nano curl wget docker

COPY ./shared/bashrc.sh /tmp/bashrc
RUN touch ~/.bashrc
RUN cat /tmp/bashrc >> ~/.bashrc

VOLUME /var/run/docker.sock /var/run/docker.sock

##COPY ./shared/bashrc.sh /h/.bashrc
##RUN apk add --no-cache bash git vim nano curl wget composer nodejs npm yarn python3 py3-pip mysql-client postgresql-client

CMD ["bash"]