# Docker Alpine Node.js 14

Alpine Linux based Docker image with Node.js 14.x, yarn, and development tools.

## Features

- Node.js 14.x
- yarn package manager
- Essential build tools (gcc, g++, make, python3)
- Non-root docker user with sudo access
- Multi-architecture support (AMD64/ARM64)

## Usage

```bash
docker build -t madebymode/alpine-node:14 .
```

With custom user ID/GID:

```bash
docker build --build-arg HOST_USER_UID=$(id -u) --build-arg HOST_USER_GID=$(id -g) -t madebymode/alpine-node:14 .
```