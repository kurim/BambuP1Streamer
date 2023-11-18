#!/bin/sh

mkdir build
cd build

arch=$(uname -m)

if [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
        # Actions to perform for aarch64 or arm64
        echo "This is aarch64 or arm64 architecture."
        # Add commands specific to aarch64 or arm64 here
        wget -q https://public-cdn.bambulab.com/upgrade/studio/plugins/01.07.01.04/linux_01.07.01.04.zip
        unzip linux_01.07.01.04.zip

        wget -q https://github.com/AlexxIT/go2rtc/releases/download/v1.6.2/go2rtc_linux_arm64
        chmod a+x go2rtc_linux_arm64

elif [ "$arch" = "x86_64" ]; then
        # Actions to perform for x86_64
        echo "This is x86_64 architecture."
        wget -q https://public-cdn.bambulab.com/upgrade/studio/plugins/01.07.01.04/linux_01.07.01.04.zip
        unzip linux_01.04.00.15.zip

        wget -q https://github.com/AlexxIT/go2rtc/releases/download/v1.6.2/go2rtc_linux_amd64
        chmod a+x go2rtc_linux_amd64

else
    # Default action if architecture is neither aarch64/arm64 nor x86_64
    echo "Unknown or unsupported architecture: $arch"
    # Add commands for handling other architectures here, if needed

fi
