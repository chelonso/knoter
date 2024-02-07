#!/bin/bash

# check if Docker installed

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR : Docker not installed."
  exit 1
fi

# get Docker version
version=$(docker version --format '{{.Server.Version}}')

echo "Docker Versión: $version"

# build the first Command & Control CLI Container
(docker build -f ./dockerfiles/Bashd.dockerfile . -t knoter-bashd)

# build the Git Container
(docker build -f ./dockerfiles/Git.dockerfile . -t knoter-git)

# build the PHP & Composer Container
(docker build -f ./dockerfiles/PHPTools.dockerfile . -t knoter-phptools)

# build the NodeJs NPM and Yarn Container
(docker build -f ./dockerfiles/JSTools.dockerfile . -t knoter-jstools)