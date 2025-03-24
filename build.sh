docker buildx build \
    --build-arg HOST_UID=1000 \
    --build-arg HOST_GID=$(getent group docker | cut -d: -f3) \
    -t matlab:R2024a .
