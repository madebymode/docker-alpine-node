ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine
MAINTAINER madebymode

# Build arguments
ARG INSTALL_CHROME=false
ARG GULP_VERSION=""

# Install system dependencies and build tools for imagemin
RUN apk add --no-cache \
    curl \
    wget \
    git \
    bash \
    sudo \
    make \
    gcc \
    g++ \
    python3 \
    py3-pip \
    autoconf \
    automake \
    libtool \
    nasm \
    libpng-dev \
    libjpeg-turbo-dev \
    giflib-dev \
    tiff-dev \
    zlib-dev \
    openssh-client \
    su-exec \
    graphicsmagick

# Install Chrome dependencies for Puppeteer (only if INSTALL_CHROME=true)
RUN if [ "$INSTALL_CHROME" = "true" ]; then \
        apk add --no-cache \
            chromium \
            nss \
            freetype \
            freetype-dev \
            harfbuzz \
            ca-certificates \
            ttf-freefont \
            ttf-dejavu \
            fontconfig; \
    fi

# Tell Puppeteer to use installed Chromium (only if Chrome is installed)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install yarn globally (force overwrite if exists)
RUN npm install -g yarn --force

# Install gulp globally if GULP_VERSION is specified
RUN if [ -n "$GULP_VERSION" ]; then \
        npm install -g gulp-cli gulp@^${GULP_VERSION}; \
    fi

# Give node user sudo access
RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy entrypoint script
COPY _shared/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["bash"]