#!/bin/sh

actions() {
	scripts/get_deps.sh
	scripts/build_bin.sh $container
	scripts/build_container.sh $container
}

podmon() {
	# Check if Podman is installed
	if [ -x "$(which podman)" ]; then
		echo "Podman is installed."
		container=podman
		actions
	else
		echo "Please install docker or Podmon"
	fi
}

# Check if Docker is installed
if [ -x "$(which docker)" ]; then
    echo "Docker is installed."
    container=docker
	actions
else
    podmon
fi

