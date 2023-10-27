FROM docker.io/docker:24.0.6-dind-alpine3.18

RUN apk update && apk add curl wget bash openssh-server shadow

RUN addgroup docker && adduser -u 1000 -s /bin/bash -D alpine -G docker &&\
    echo "alpine:12345" | chpasswd

RUN mkdir -p /run/sshd &&\
    ssh-keygen -A

COPY ./entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

EXPOSE 22

CMD ["/app/entrypoint.sh"]
