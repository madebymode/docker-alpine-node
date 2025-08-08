FROM node:14-alpine
MAINTAINER madebymode

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
    zlib-dev

# Install yarn globally (force overwrite if exists)
RUN npm install -g yarn --force

# Give node user sudo access
RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy entrypoint script
COPY _shared/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["bash"]