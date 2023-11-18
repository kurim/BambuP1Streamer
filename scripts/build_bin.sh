#!/bin/sh

container=$1

$container run --rm -v $(pwd):/work docker.io/gcc:12 gcc /work/src/BambuP1Streamer.cpp -o /work/build/BambuP1Streamer 
