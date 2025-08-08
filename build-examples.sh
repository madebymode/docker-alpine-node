#!/bin/bash
# Example usage of the new build system

# Build Node 20 with gulp 5 (standard)
./buildx-local.sh --version 20 --type gulp5 --force

# Build Node 20 with gulp 4 + Chrome (full)
./buildx-local.sh --version 20 --type gulp4-full --force

# Build all gulp variants for Node 18
./buildx-local.sh --version 18 --type gulp4
./buildx-local.sh --version 18 --type gulp5
./buildx-local.sh --version 18 --type gulp4-full
./buildx-local.sh --version 18 --type gulp5-full

# Available tags will be:
# mxmd/node:v20-gulp4
# mxmd/node:v20-gulp5
# mxmd/node:v20-gulp4-full  
# mxmd/node:v20-gulp5-full
# mxmd/node:v20 (base, no gulp)
# mxmd/node:v20-full (base + chrome, no gulp)

echo "Images built with SSH support. To use SSH:"
echo "docker run -v ~/.ssh:/home/docker/.ssh-copy:ro mxmd/node:v20-gulp5"

