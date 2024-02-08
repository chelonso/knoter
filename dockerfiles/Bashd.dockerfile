FROM alpine:latest

RUN apk add --no-cache bash nano curl wget docker nerd-fonts

COPY ./shared/bashrc.sh /tmp/bashrc
RUN touch ~/.bashrc
RUN cat /tmp/bashrc >> ~/.bashrc

CMD ["bash"]