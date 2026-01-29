#!/bin/bash

sudo chmod 777 /dev/ttyUSB0

podman run -it --rm \
  --userns=keep-id \
  -v $(pwd):/home/ersli-osdev/repo:Z \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \
  localhost/h8-dev-env /bin/bash
  