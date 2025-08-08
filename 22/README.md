# Docker Alpine Node.js 22

Alpine Linux based Docker image with Node.js 22.x, yarn, and development tools.

## Features

- Node.js 22.x
- yarn package manager
- Essential build tools (gcc, g++, make, python3)
- Non-root node user with sudo access
- Multi-architecture support (AMD64/ARM64)

## Usage

```bash
docker build -t madebymode/alpine-node:22 .
```

With custom user ID/GID:

```bash
docker build --build-arg HOST_USER_UID=$(id -u) --build-arg HOST_USER_GID=$(id -g) -t madebymode/alpine-node:22 .
```