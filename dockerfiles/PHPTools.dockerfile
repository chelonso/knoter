FROM alpine:latest

RUN apk add --no-cache \
    bash \
    php82 \
    php82-cli \
    php82-json \
    php82-phar \
    php82-openssl \
    php82-curl \
    php82-dom \ 
    composer && rm -rf /var/cache/apk/*

CMD ["bash"]