#!/usr/bin/env bash

term_handler() {
  docker stop $(docker ps -a -q);

  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM;

set -e;

set +e
/usr/local/bin/dockerd-entrypoint.sh dockerd --host=tcp://0.0.0.0:2375 --host=unix:///var/run/docker.sock -G docker --insecure-registry local-registry:5000 &
set -e
until [ -e /var/run/docker.sock ]
do
     sleep 1
done
/usr/sbin/sshd -D &

while true; do
    sleep 5 &
    wait $!;
done
