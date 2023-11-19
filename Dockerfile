# Stage 1: Build-Stage
FROM docker.io/gcc:12 AS builder

# Workdir for Build Stage
WORKDIR /work

# install wget and unzip
RUN apt-get update && apt-get install -y wget unzip

# Download needed content
RUN wget -q https://public-cdn.bambulab.com/upgrade/studio/plugins/01.05.00.10/linux_01.05.00.10.zip
RUN unzip linux_01.05.00.10.zip -d /work/build

# Copy source to Build-Stage
COPY src/BambuP1Streamer.cpp src/BambuTunnel.h /work/src/

# Compile C++
RUN gcc /work/src/BambuP1Streamer.cpp -o /work/build/BambuP1Streamer

# Main-Image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y wget curl ffmpeg
RUN apt-get upgrade -y

RUN mkdir -p /app
COPY go2rtc.yaml /app/
COPY --from=builder /work/build/ /app/

# Download latest version of go2rtc based on arch
ARG TARGETARCH

RUN VER=$(curl --silent -qI https://github.com/AlexxIT/go2rtc/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}') ;\
    wget -P /app -q https://github.com/AlexxIT/go2rtc/releases/download/$VER/go2rtc_linux_amd64 ; \
    mv /app/go2rtc_linux_amd64 /app/go2rtc ; \
    chmod a+x /app/go2rtc

WORKDIR /app

ENV PRINTER_ADDRESS=
ENV PRINTER_ACCESS_CODE=

EXPOSE 8554
CMD ["./go2rtc"]
