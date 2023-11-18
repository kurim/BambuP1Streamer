#!/bin/sh

[ -z "$2" ] && echo "Usage: $0 <PRINTER_ADDRESS> <PRINTER_ACCESS_CODE>" && exit 1

PRINTER_ADDRESS=$1
PRINTER_ACCESS_CODE=$2

run() {

$container run -d --name bambu_p1_streamer -p 1984:1984 -e PRINTER_ADDRESS=$PRINTER_ADDRESS -e PRINTER_ACCESS_CODE=$PRINTER_ACCESS_CODE bambu_p1_streamer

}

podmon() {
	# Check if Podman is installed
	if [ -x "$(which podman)" ]; then
		container=podman
		run
	else
		echo "Please install docker or Podmon"
	fi
}

# Check if Docker is installed
if [ -x "$(which docker)" ]; then
    container=docker
	run
else
    podmon
fi