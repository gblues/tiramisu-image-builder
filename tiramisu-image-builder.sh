#!/usr/bin/env bash

docker=$(command -v docker)
if [ -z "$docker" ]; then
  echo "Docker not found on path. Cannot continue."
  exit 1
fi

force_rebuild=

container_params=()

for param in $@; do
  is_switch=$(echo $param | grep -o '^--')
  if [ -z "$is_switch" ]; then
    container_params+=($param)
  else
    if [ ${#ArrayName[@]} -eq 0 ]; then
      case $param in
        --rebuild)
          force_rebuild=true
          ;;
        --help)
          cat << EOF
Tiramisu SD card image builder
usage: $(basename $0) [--rebuild] <size>

<size> should be the size of your SD card, in gigabytes (base 10) **not** 
gibibytes (base 2). Generally, this will be the manufacturer's advertised size
printed on the SD card label.

Options:
  --rebuild      Forces the Docker container to be rebuilt

The image will be saved in your working directory as "disk.img" and can be
flashed to your SD card using an image flashing tool such as Balena Etcher.
EOF

          exit 1
          ;;
        *)
          echo "WARN: unrecognized parameter $param, ignoring"
          ;;
      esac
    else
      container_params+=($param)
    fi

  fi
done

image_hash=$(docker images -q tiramisu:latest)
if [ -z "$image_hash" ] || [ "$force_rebuild" == "true" ]; then
  docker build . -t tiramisu
fi

# NB: The container needs to run as privileged so the container can
#     mount the disk image on the loopback interface.
docker run --privileged --rm -it -v $(pwd):/mnt/work $image_hash ${container_params[@]}
