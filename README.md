# cross platform alpine-based Node.js 14 - 22 images

## Front-End Asset Building

### Using Docker Node.js Images from Docker Hub

This repository builds and publishes Node.js images optimized for front-end asset building and compilation. These images are designed for building JavaScript, CSS, and other front-end assets, not for running Node.js applications in production. Our images are compatible with both ARM64 and x86_64 host architectures and integrate seamlessly with modern build tools like Webpack, Vite, Rollup, and other front-end bundlers.

#### Pulling our Node.js Docker Images

To get a specific version of our Node.js image, use:

```bash
docker pull mxmd/node:<VERSION>
```

Where:
- `<VERSION>` is the desired Node.js major version (e.g., `14`, `16`, `18`, `20`, `22`).
- For images with Chrome/Puppeteer support, append `-full` to the version (e.g., `18-full`).

For example, to pull the Node.js 18 image:

```bash
docker pull mxmd/node:18
```

Or to pull the Node.js 18 image with Chrome/Puppeteer support:

```bash
docker pull mxmd/node:18-full
```

Available versions of our images along with their Docker Hub links:

- [14](https://hub.docker.com/r/mxmd/node/tags?page=1&name=14), [14-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=14-full)
- [16](https://hub.docker.com/r/mxmd/node/tags?page=1&name=16), [16-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=16-full)
- [18](https://hub.docker.com/r/mxmd/node/tags?page=1&name=18), [18-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=18-full)
- [20](https://hub.docker.com/r/mxmd/node/tags?page=1&name=20), [20-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=20-full)
- [22](https://hub.docker.com/r/mxmd/node/tags?page=1&name=22), [22-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=22-full)

#### Image Types

**Standard Images**: Include Node.js with essential build tools and dependencies for front-end asset compilation:
- Build tools (make, gcc, g++, python3) for native module compilation
- Image processing libraries (libpng, libjpeg-turbo, libwebp) for imagemin and asset optimization
- Git, curl, wget, bash for package management and build scripts

**Full Images** (with `-full` suffix): Include everything from standard images plus:
- Chromium browser for headless testing and screenshot generation during builds
- Additional Chrome dependencies for Puppeteer-based build tasks
- Pre-configured environment variables for Puppeteer integration

#### Usage with Docker Compose

You can integrate our Node.js images into your front-end build workflows:

```yaml
services:
  frontend-build:
    image: mxmd/node:18
    container_name: frontend-builder
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=production
      # these are CRITICAL for linux hosts
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: yarn && yarn build
    
  frontend-build-with-testing:
    image: mxmd/node:18-full
    container_name: frontend-builder-full
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=production
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    user: docker
    shm_size: 1gb
    command: |
      sh -c "yarn && yarn build && yarn test:e2e"
```

**Note**: The `shm_size: 1gb` is recommended for `-full` images when running Puppeteer/Chrome-based tests during the build process.

### Required Environment Variables

Ensure these environment variables exist on your host machine:

```bash
HOST_USER_GID
HOST_USER_UID
```

#### Setting these Environment Variables

On `macOS`, you can set them in `~/.extra` or `~/.bash_profile`.

To get `HOST_USER_UID`:

```bash
id -u
```

To get `HOST_USER_GID`:

```bash
id -g
```

To set these on your host machine:

```bash
echo "export HOST_USER_GID=$(id -g)" >> ~/.bash_profile && echo "export HOST_USER_UID=$(id -u)" >> ~/.bash_profile && echo "export DOCKER_USER=$(id -u):$(id -g)" >> ~/.bash_profile
```

---

## Building Images

### Local Development

Each Node.js version directory contains a `docker-compose.yml` file for easy local development:

```bash
cd 18  # or any version directory
docker-compose up -d
```

This will build and start the container with your project files mounted and accessible at `/app`.

### Local Docker Buildx Multi-Architecture Build

Use the provided `buildx-local.sh` script for building multi-architecture images:

```bash
./buildx-local.sh --version 18 --type regular  # for standard image
./buildx-local.sh --version 18 --type full     # for full image with Chrome
```

## GitHub Actions

### Workflow Description

**Trigger**:
- Activates on `push` events to the `master` or `main` branch.
- Can be manually triggered via `workflow_dispatch`.

**Jobs**:

1. **create-release-and-build**:
   - **Environment**: Runs on the latest Ubuntu.
   - **Matrix Strategy**: Builds combinations of Node.js versions ('14', '16', '18', '20', '22') for both 'regular' and 'full' image types.

   **Steps**:
   - **Checkout repository**: Pulls the latest code from the repository.
   - **Setup GitHub CLI**: Initializes the GitHub CLI and logs in using the provided GitHub token.
   - **Create Releases**: Creates GitHub releases for each Node.js version and type combination.
   - **Set up QEMU**: Enables multi-architecture builds.
   - **Set up Docker Buildx**: Initializes Buildx for advanced building features.
   - **Log in to Docker Hub**: Authenticates with Docker Hub using provided secrets.
   - **Build Docker images**: Constructs Docker images for both amd64 and arm64 platforms.
   - **Push Docker images**: Pushes the built images to Docker Hub with version tags and timestamped tags.

### Key Features

- **Matrix Builds**: Builds multiple Node.js versions and types concurrently for maximum efficiency.
- **Multi-Architecture**: Supports both amd64 and arm64 architectures.
- **Automated Releases**: Creates GitHub releases and publishes to Docker Hub automatically.
- **Timestamped Tags**: Each build gets both a version tag and a timestamped tag for precise versioning.

### Required Secrets

The workflow requires the following secrets:

- `GITHUB_TOKEN`: Automatically provided by GitHub Actions for repository operations.
- `DOCKER_HUB_USERNAME`: Your Docker Hub username.
- `DOCKER_HUB_ACCESS_TOKEN`: Docker Hub access token for authentication and image pushing.
