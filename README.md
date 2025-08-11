# cross platform alpine-based Node.js 14 - 22 images

## Front-End Asset Building

### Using Docker Node.js Images from Docker Hub

This repository builds and publishes Node.js images built on top of the official Alpine-based Node.js images (`node:v${VERSION}-alpine`). These images are optimized for front-end asset building and compilation. These images are designed for building JavaScript, CSS, and other front-end assets, not for running Node.js applications in production. Our images are compatible with both ARM64 and x86_64 host architectures and integrate seamlessly with modern build tools like Webpack, Vite, Rollup, and other front-end bundlers.

#### Pulling our Node.js Docker Images

To get a specific version of our Node.js image, use:

```bash
docker pull mxmd/node:v<VERSION>
```

Where:
- `<VERSION>` is the desired Node.js major version (e.g., `v14`, `v16`, `v18`, `v20`, `v22`).
- For images with Chrome/Puppeteer support, append `-full` to the version (e.g., `v18-full`).

For example, to pull the Node.js 18 image:

```bash
docker pull mxmd/node:v18
```

Or to pull the Node.js 18 image with Chrome/Puppeteer support:

```bash
docker pull mxmd/node:v18-full
```

Available versions of our images along with their Docker Hub links:

**Base versions:**
- [14](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14), [16](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16), [18](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18), [20](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20), [22](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22)

**Chrome-enabled versions:**
- [14-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14-full), [16-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16-full), [18-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18-full), [20-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20-full), [22-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22-full)

**Gulp-specific versions:**
- [14-gulp4](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14-gulp4), [16-gulp4](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16-gulp4), [18-gulp4](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18-gulp4), [20-gulp4](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20-gulp4), [22-gulp4](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22-gulp4)
- [14-gulp5](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14-gulp5), [16-gulp5](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16-gulp5), [18-gulp5](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18-gulp5), [20-gulp5](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20-gulp5), [22-gulp5](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22-gulp5)
- [14-gulp4-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14-gulp4-full), [16-gulp4-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16-gulp4-full), [18-gulp4-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18-gulp4-full), [20-gulp4-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20-gulp4-full), [22-gulp4-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22-gulp4-full)
- [14-gulp5-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v14-gulp5-full), [16-gulp5-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v16-gulp5-full), [18-gulp5-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v18-gulp5-full), [20-gulp5-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v20-gulp5-full), [22-gulp5-full](https://hub.docker.com/r/mxmd/node/tags?page=1&name=v22-gulp5-full)

#### Image Types

**Standard Images** (e.g., `18`, `20`, `22`): Include Node.js with essential build tools and dependencies for front-end asset compilation:
- Build tools (make, gcc, g++, python3) for native module compilation
- Image processing libraries (libpng, libjpeg-turbo, libwebp) for imagemin and asset optimization
- Git, curl, wget, bash for package management and build scripts

**Full Images** (with `-full` suffix): Include everything from standard images plus:
- Chromium browser for headless testing and screenshot generation during builds
- Additional Chrome dependencies for Puppeteer-based build tasks
- Pre-configured environment variables for Puppeteer integration

**Gulp Images**: Include everything from standard images plus pre-installed Gulp:
- `gulp4` variants: Pre-installed Gulp 4.0.0 for legacy projects
- `gulp5` variants: Pre-installed Gulp 5.0.0 for modern projects
- `gulp4-full` and `gulp5-full` variants: Combine Gulp installation with Chrome/Puppeteer support

#### Usage with Docker Compose

You can integrate our Node.js images into your front-end build workflows. Here are several common use cases:

##### Basic Build Service

```yaml
services:
  frontend-build:
    image: mxmd/node:v18
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
```

##### Build with Chrome/Puppeteer Testing

```yaml
services:
  frontend-build-with-testing:
    image: mxmd/node:v18-full
    container_name: frontend-builder-full
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=production
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    shm_size: 1gb
    command: |
      sh -c "yarn && yarn build && yarn test:e2e"
```

##### Development with Watch Mode

```yaml
services:
  dev-server:
    image: mxmd/node:v20
    container_name: dev-server
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
      - "5173:5173"  # Vite dev server
    environment:
      - NODE_ENV=development
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: yarn && yarn dev
```

##### Multi-Stage Build Pipeline

```yaml
services:
  install-deps:
    image: mxmd/node:v18
    working_dir: /app
    volumes:
      - .:/app
      - node_modules:/app/node_modules
    environment:
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: yarn install --frozen-lockfile

  build-assets:
    image: mxmd/node:v18
    working_dir: /app
    volumes:
      - .:/app
      - node_modules:/app/node_modules
      - build_output:/app/dist
    environment:
      - NODE_ENV=production
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: yarn build
    depends_on:
      - install-deps

  run-tests:
    image: mxmd/node:v18-full
    working_dir: /app
    volumes:
      - .:/app
      - node_modules:/app/node_modules
    environment:
      - NODE_ENV=test
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    shm_size: 1gb
    command: yarn test
    depends_on:
      - install-deps

volumes:
  node_modules:
  build_output:
```

##### Gulp-Specific Build

```yaml
services:
  gulp-build:
    image: mxmd/node:v18-gulp4
    container_name: gulp-builder
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=production
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: |
      sh -c "npm install && gulp build"
```

##### With SSH Keys for Private Repositories

```yaml
services:
  build-with-ssh:
    image: mxmd/node:v20
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
      - ~/.ssh:/home/node/.ssh-copy:ro  # SSH keys mounted as read-only
    environment:
      - NODE_ENV=production
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
    command: |
      sh -c "yarn install && yarn build"
```

##### Complete Development Environment

```yaml
services:
  frontend:
    image: mxmd/node:v20-full
    container_name: frontend-dev
    working_dir: /app
    volumes:
      - .:/app
      - /app/node_modules
      - ~/.ssh:/home/node/.ssh-copy:ro
    ports:
      - "3000:3000"
      - "5173:5173"
      - "8080:8080"
    environment:
      - NODE_ENV=development
      - HOST_USER_UID=${HOST_USER_UID:-1000}
      - HOST_USER_GID=${HOST_USER_GID:-1000}
      - CHOKIDAR_USEPOLLING=true  # For file watching in containers
    shm_size: 1gb
    stdin_open: true
    tty: true
    command: bash  # Interactive shell for development
```

**Important Notes:**
- The `shm_size: 1gb` is recommended for `-full` images when running Puppeteer/Chrome-based tests
- SSH keys are automatically configured by the entrypoint when mounted to `/home/node/.ssh-copy`
- Use `CHOKIDAR_USEPOLLING=true` for file watching in development containers
- The entrypoint handles user ID/group ID mapping for proper file permissions

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
# Build specific variant for a version
./buildx-local.sh --version 18 --type regular      # Standard Node.js 18 image
./buildx-local.sh --version 18 --type full         # Node.js 18 with Chrome
./buildx-local.sh --version 18 --type gulp4        # Node.js 18 with Gulp 4.0.0
./buildx-local.sh --version 18 --type gulp5        # Node.js 18 with Gulp 5.0.0
./buildx-local.sh --version 18 --type gulp4-full   # Node.js 18 with Gulp 4.0.0 + Chrome
./buildx-local.sh --version 18 --type gulp5-full   # Node.js 18 with Gulp 5.0.0 + Chrome

# Build all variants for a specific version
./buildx-local.sh --version 18

# Build all versions and variants
./buildx-local.sh --all

# Build with custom platforms
./buildx-local.sh --version 18 --type full --platform linux/amd64

# Force rebuild (skip 24h freshness check)
./buildx-local.sh --version 18 --type full --force
```

## GitHub Actions

### Workflow Description

**Trigger**:
- Activates on `push` events to the `master` or `main` branch.
- Can be manually triggered via `workflow_dispatch`.

**Jobs**:

1. **create-release-and-build**:
   - **Environment**: Runs on the latest Ubuntu.
   - **Matrix Strategy**: Builds combinations of Node.js versions ('14', '16', '18', '20', '22') with all image variants ('regular', 'full', 'gulp4', 'gulp5', 'gulp4-full', 'gulp5-full').

   **Steps**:
   - **Checkout repository**: Pulls the latest code from the repository.
   - **Setup GitHub CLI**: Initializes the GitHub CLI and logs in using the provided GitHub token.
   - **Create Releases**: Creates GitHub releases for each Node.js version and type combination.
   - **Set up QEMU**: Enables multi-architecture builds.
   - **Set up Docker Buildx**: Initializes Buildx for advanced building features.
   - **Log in to Docker Hub**: Authenticates with Docker Hub using provided secrets.
   - **Build Docker images**: Uses a unified Dockerfile with build arguments to construct images for both amd64 and arm64 platforms.
   - **Push Docker images**: Pushes the built images to Docker Hub with version tags and timestamped tags.

### Key Features

- **Consolidated Architecture**: Single Dockerfile per Node.js version supports all variants through build arguments
- **Matrix Builds**: Builds multiple Node.js versions and all variant types concurrently for maximum efficiency
- **Multi-Architecture**: Supports both amd64 and arm64 architectures
- **Flexible Build Types**: Standard, Chrome-enabled, and Gulp-specific variants all from unified build system
- **Automated Releases**: Creates GitHub releases and publishes to Docker Hub automatically
- **Timestamped Tags**: Each build gets both a version tag and a timestamped tag for precise versioning

### Required Secrets

The workflow requires the following secrets:

- `GITHUB_TOKEN`: Automatically provided by GitHub Actions for repository operations.
- `DOCKER_HUB_USERNAME`: Your Docker Hub username.
- `DOCKER_HUB_ACCESS_TOKEN`: Docker Hub access token for authentication and image pushing.
