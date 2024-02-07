#!/bin/bash

(docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/code:/var/code --user root -it knoter-bashd)