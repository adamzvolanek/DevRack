#!/bin/bash

echo "========================================"
echo " Docker Dangling Image Cleanup"
echo " Started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
echo

# Retrieve dangling image IDs
IMAGE_IDS=$(docker images --quiet --filter=dangling=true)

if [ -z "$IMAGE_IDS" ]; then
    echo "[INFO] No dangling Docker images found."
    echo "[INFO] Nothing to delete."
    echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
    exit 0
fi

IMAGE_COUNT=$(echo "$IMAGE_IDS" | wc -l)

echo "[INFO] Found $IMAGE_COUNT dangling image(s)."
echo

DELETED=0
SKIPPED=0
FAILED=0

while IFS= read -r IMAGE_ID; do
    [ -z "$IMAGE_ID" ] && continue

    IMAGE_SIZE=$(docker image inspect "$IMAGE_ID" \
        --format '{{.Size}}' 2>/dev/null)

    if [ -n "$IMAGE_SIZE" ]; then
        IMAGE_SIZE=$(numfmt --to=iec-i --suffix=B "$IMAGE_SIZE" 2>/dev/null)
        IMAGE_SIZE=${IMAGE_SIZE:-Unknown}
    else
        IMAGE_SIZE="Unknown"
    fi

    echo "----------------------------------------"
    echo "[IMAGE] ID:   $IMAGE_ID"
    echo "[IMAGE] Size: $IMAGE_SIZE"

    # Find all containers using this image, including stopped containers.
    CONTAINERS=$(docker ps -a --no-trunc \
        --filter "ancestor=$IMAGE_ID" \
        --format '{{.ID}}|{{.Names}}|{{.Status}}')

    if [ -n "$CONTAINERS" ]; then
        echo "[SKIP] Image is in use by one or more containers:"
        while IFS='|' read -r CONTAINER_ID CONTAINER_NAME CONTAINER_STATUS; do
            echo "       Container: $CONTAINER_NAME"
            echo "       ID:       $CONTAINER_ID"
            echo "       Status:   $CONTAINER_STATUS"
        done <<< "$CONTAINERS"

        echo "[SKIP] Image will not be deleted."
        ((SKIPPED++))
        echo
        continue
    fi

    echo "[DELETE] Attempting to remove image $IMAGE_ID..."

    if docker rmi "$IMAGE_ID"; then
        echo "[SUCCESS] Image $IMAGE_ID deleted."
        ((DELETED++))
    else
        echo "[FAILED] Could not delete image $IMAGE_ID."
        ((FAILED++))
    fi

    echo

done <<< "$IMAGE_IDS"

echo "========================================"
echo " Cleanup Summary"
echo "========================================"
echo " Images found:   $IMAGE_COUNT"
echo " Images deleted: $DELETED"
echo " Images skipped: $SKIPPED"
echo " Images failed:  $FAILED"
echo " Finished:       $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
