FROM alpine:latest

RUN apk add --no-cache bash \
    nodejs \
    npm \
    yarn && rm -rf /var/cache/apk/*

CMD ["bash"]