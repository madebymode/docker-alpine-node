ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine
MAINTAINER madebymode

# Build arguments
ARG INSTALL_CHROME=false
ARG GULP_VERSION=""

# Install all dependencies in a single layer, then remove build deps
RUN apk add --no-cache --virtual .build-deps \
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
    && apk add --no-cache \
        curl \
        wget \
        git \
        bash \
        sudo \
        openssh-client \
        su-exec \
        graphicsmagick \
        libpng \
        libjpeg-turbo \
        giflib \
        tiff \
        zlib \
    && if [ "$INSTALL_CHROME" = "true" ]; then \
        apk add --no-cache \
            chromium \
            nss \
            freetype \
            harfbuzz \
            ca-certificates \
            ttf-freefont \
            ttf-dejavu \
            fontconfig; \
    fi \
    && npm install -g yarn --force \
    && if [ -n "$GULP_VERSION" ]; then \
        npm install -g gulp-cli gulp@^${GULP_VERSION}; \
    fi \
    && npm cache clean --force \
    && apk del .build-deps

# Tell Puppeteer to use installed Chromium (only if Chrome is installed)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Give node user sudo access
RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy entrypoint script
COPY _shared/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["bash"]