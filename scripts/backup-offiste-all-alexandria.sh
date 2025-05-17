#!/bin/bash

# === Configurable Settings ===
SKIP_SHARES=("appdata")
DELETE_SKIPPED_SHARES=false  # Set to true to delete skipped remote shares

# === Helper Function ===
is_skipped_share() {
    local share="$1"
    for skip in "${SKIP_SHARES[@]}"; do
        if [[ "$share" == "$skip" ]]; then
            return 0  # true
        fi
    done
    return 1  # false
}

# === Get all local shares ===
AllShares=($(ls -d /mnt/user/*/ | xargs -n 1 basename))

# Filter out skipped shares
ShareNames=()
for share in "${AllShares[@]}"; do
    if is_skipped_share "$share"; then
        echo "Skipping excluded local share: $share"
        continue
    fi
    ShareNames+=("$share")
done

# === Get remote shares ===
RemoteShares=($(ls -d /mnt/remotes/999.999.999.999_bigdrive/*/ 2>/dev/null | xargs -n 1 basename))

# === Delete stale remote shares if not found locally ===
for RemoteShare in "${RemoteShares[@]}"; do
    if [[ ! " ${AllShares[@]} " =~ " ${RemoteShare} " ]]; then
        echo "Remote share '${RemoteShare}' no longer exists locally."

        if is_skipped_share "$RemoteShare"; then
            if [[ "$DELETE_SKIPPED_SHARES" == true ]]; then
                echo "Deleting skipped remote share: $RemoteShare"
                rm -rf "/mnt/remotes/999.999.999.999_bigdrive/${RemoteShare}"
            else
                echo "Preserving skipped remote share: $RemoteShare"
            fi
        else
            echo "Deleting stale remote share: $RemoteShare"
            rm -rf "/mnt/remotes/999.999.999.999_bigdrive/${RemoteShare}"
        fi
    fi
done

# === Sync eligible shares ===
for ShareName in "${ShareNames[@]}"; do
    StartTime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Starting Rsync for ${ShareName} at ${StartTime}"

    LOG_FILE="/mnt/user/logs/offsite_logs/${ShareName}_log.txt"

    echo "Deleting previous log for ${ShareName}"
    rm -f "$LOG_FILE"

    echo "Running Rsync Sync of ${ShareName} Share to Offsite Server via SMB Share"

    # Rsync sync command
    rsync -avqh -P --exclude='.Recycle.Bin/' --log-file="$LOG_FILE" \
      --stats \
      --delete \
      "/mnt/user/${ShareName}/" "/mnt/remotes/999.999.999.999_bigdrive/${ShareName}"

    EndTime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Rsync for ${ShareName} completed at ${EndTime}"

    ElapsedTime=$((SECONDS))
    echo "Time taken for Rsync on ${ShareName}: ${ElapsedTime} seconds" | tee -a "$LOG_FILE"

    echo "Updating permissions of log file for ${ShareName}"
    chmod 755 "$LOG_FILE"

    # Reset the SECONDS counter for the next loop iteration
    SECONDS=0
done
