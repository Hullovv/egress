#!/bin/bash

CUDA_CANDIDATES=$(apt-cache policy cuda | tail -n +5 | sed 's/600/''/g' | sed 's/Packages/''/g' | sed -e 's/https:\/\/developer.download.nvidia.com\/compute\/cuda\/repos\/ubuntu2204\/x86_64//g' | tr "\n" " " | tr -s "[:space:]")
for c in $CUDA_CANDIDATES; do
    echo -e cuda=$c
    echo -e $(apt-cache depends -i --recurse cuda=$c) | tr " " "\n" | grep "nvidia-driver"
    echo -e "================================\n"
done