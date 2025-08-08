#!/bin/sh

# Modify node user and group IDs to match the host user and group IDs if the arguments are passed and not macOS
if [ -n "$HOST_USER_UID" ] && [ -n "$HOST_USER_GID" ] && [ "$(uname)" != "Darwin" ] && [ "$HOST_USER_GID" != "20" ]; then
    # Use deluser/adduser instead of usermod/groupmod as they're more reliable in Alpine
    deluser node 2>/dev/null || true
    delgroup node 2>/dev/null || true
    addgroup -g $HOST_USER_GID node
    adduser -D -u $HOST_USER_UID -G node node
    # Add sudo access
    echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
else
    echo "Skipping user/group modification due to macOS or GID 20"
    # fix warnings for npm/yarn on macOS
    echo "handling npm/yarn behaviors for macOS or GID 20"
    if command -v git >/dev/null 2>&1; then
        git config --global --add safe.directory /app 2>/dev/null || true
    fi
fi

# bash and sh commands should run as node user
COMMAND="exec"
if [ -n "$HOST_USER_UID" ] && [ -n "$HOST_USER_GID" ] && [ "$(uname)" != "Darwin" ] && [ "$HOST_USER_GID" != "20" ]; then
    COMMAND="su-exec node"
fi
# run as root if explicitly requested
if [ "$EXEC_AS_ROOT" = "true" ] || [ "$EXEC_AS_ROOT" = "1" ]; then
    COMMAND="exec"
fi

# Install su-exec if not available (for user switching)
if [ "$COMMAND" = "su-exec node" ] && ! command -v su-exec >/dev/null 2>&1; then
    apk add --no-cache su-exec
fi

# Execute the passed command with the correct user
$COMMAND "$@"