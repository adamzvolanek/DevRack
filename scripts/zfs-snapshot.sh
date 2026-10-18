#!/bin/bash

# ============================================================
# Unraid ZFS Snapshot User Script
#
# DAILY:
#   - One snapshot per calendar day
#   - Retains newest 7
#
# WEEKLY:
#   - One snapshot every 7 days
#   - Retains newest 3
#
# SNAPSHOT FORMAT:
#   <YOUR_ZFS_POOL>/<DATASET>@daily-YYYY-MM-DD-HHMMSS
#   <YOUR_ZFS_POOL>/<DATASET>@weekly-YYYY-MM-DD-HHMMSS
#
# LOGS:
#   <YOUR_LOG_DIRECTORY>/
#   One log file per day
#   Logs older than 7 days are removed
#
# SAFETY:
#   - Only operates on explicitly configured datasets
#   - Only deletes snapshots created by this script
#   - Individual dataset failures do not stop the entire job
#   - Duplicate daily runs are ignored
#   - Duplicate weekly runs are ignored
# ============================================================

set -u
set -o pipefail

# ============================================================
# CONFIGURATION
# ============================================================

POOL="<YOUR_ZFS_POOL>"

DATASETS=(
    "<DATASET_1>"
    "<DATASET_2>"
    "<DATASET_3>"
    # Add additional dataset names as needed:
    # "<DATASET_4>"
)

DAILY_RETENTION=7
WEEKLY_RETENTION=3

# 7 days in seconds
WEEKLY_INTERVAL=$((7 * 24 * 60 * 60))

LOG_DIR="<YOUR_LOG_DIRECTORY>"

# ============================================================
# INITIALIZATION
# ============================================================

mkdir -p "$LOG_DIR"

TODAY=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d-%H%M%S')

LOG_FILE="${LOG_DIR}/zfs-snapshots-${TODAY}.log"

# ============================================================
# LOGGING
# ============================================================

log() {
    local MESSAGE="$1"
    local LOG_TIMESTAMP

    LOG_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Send output to:
    #   - Unraid User Scripts execution window
    #   - Daily log file
    echo "${LOG_TIMESTAMP} - ${MESSAGE}" | tee -a "$LOG_FILE"
}

# ============================================================
# ERROR HANDLING
# ============================================================

log "============================================================"
log "ZFS snapshot job starting"
log "============================================================"

log "Pool: $POOL"
log "Date: $(date '+%Y-%m-%d')"
log "Time: $(date '+%H:%M:%S')"
log "Snapshot timestamp: $TIMESTAMP"

# ============================================================
# VERIFY REQUIRED COMMANDS
# ============================================================

if ! command -v zfs >/dev/null 2>&1; then
    log "ERROR: zfs command is not available."
    exit 1
fi

if ! command -v zpool >/dev/null 2>&1; then
    log "ERROR: zpool command is not available."
    exit 1
fi

# ============================================================
# VERIFY POOL
# ============================================================

if ! zpool list -H -o name "$POOL" >/dev/null 2>&1; then
    log "ERROR: ZFS pool '$POOL' does not exist or is unavailable."
    exit 1
fi

log "ZFS pool '$POOL' is available."

# ============================================================
# DATASET VALIDATION
# ============================================================

dataset_exists() {
    local DATASET="$1"

    zfs list -H -o name "$DATASET" >/dev/null 2>&1
}

# ============================================================
# CHECK FOR DAILY SNAPSHOT
#
# Looks specifically for:
#
#   dataset@daily-YYYY-MM-DD-*
#
# This prevents duplicate daily snapshots if the script is
# manually executed more than once in the same day.
# ============================================================

daily_snapshot_exists() {
    local DATASET="$1"

    zfs list -H -t snapshot -o name \
        | grep -q "^${DATASET}@daily-${TODAY}-"
}

# ============================================================
# CREATE DAILY SNAPSHOTS
# ============================================================

create_daily_snapshots() {

    log "------------------------------------------------------------"
    log "Creating daily snapshots"
    log "------------------------------------------------------------"

    local SUCCESS=0
    local FAILED=0
    local SKIPPED=0

    for DATASET_NAME in "${DATASETS[@]}"; do

        DATASET="${POOL}/${DATASET_NAME}"

        # ----------------------------------------------------
        # Verify dataset exists
        # ----------------------------------------------------

        if ! dataset_exists "$DATASET"; then
            log "ERROR: Dataset unavailable: $DATASET"
            ((FAILED++))
            continue
        fi

        # ----------------------------------------------------
        # Prevent duplicate daily snapshots
        # ----------------------------------------------------

        if daily_snapshot_exists "$DATASET"; then
            log "SKIPPED: Daily snapshot already exists for $DATASET"
            ((SKIPPED++))
            continue
        fi

        # ----------------------------------------------------
        # Create snapshot
        # ----------------------------------------------------

        SNAPSHOT="${DATASET}@daily-${TIMESTAMP}"

        if zfs snapshot "$SNAPSHOT"; then
            log "CREATED: $SNAPSHOT"
            ((SUCCESS++))
        else
            log "ERROR: Failed to create $SNAPSHOT"
            ((FAILED++))
        fi
    done

    log "Daily snapshot results:"
    log "  Created: $SUCCESS"
    log "  Skipped: $SKIPPED"
    log "  Failed:  $FAILED"
}

# ============================================================
# CREATE WEEKLY SNAPSHOTS
# ============================================================

create_weekly_snapshots() {

    log "------------------------------------------------------------"
    log "Creating weekly snapshots"
    log "------------------------------------------------------------"

    local SUCCESS=0
    local FAILED=0
    local SKIPPED=0

    for DATASET_NAME in "${DATASETS[@]}"; do

        DATASET="${POOL}/${DATASET_NAME}"

        # ----------------------------------------------------
        # Verify dataset exists
        # ----------------------------------------------------

        if ! dataset_exists "$DATASET"; then
            log "ERROR: Dataset unavailable: $DATASET"
            ((FAILED++))
            continue
        fi

        # ----------------------------------------------------
        # Prevent duplicate weekly snapshots for today
        # ----------------------------------------------------

        if zfs list -H -t snapshot -o name \
            | grep -q "^${DATASET}@weekly-${TODAY}-"; then

            log "SKIPPED: Weekly snapshot already exists for $DATASET"
            ((SKIPPED++))
            continue
        fi

        # ----------------------------------------------------
        # Create snapshot
        # ----------------------------------------------------

        SNAPSHOT="${DATASET}@weekly-${TIMESTAMP}"

        if zfs snapshot "$SNAPSHOT"; then
            log "CREATED: $SNAPSHOT"
            ((SUCCESS++))
        else
            log "ERROR: Failed to create $SNAPSHOT"
            ((FAILED++))
        fi
    done

    log "Weekly snapshot results:"
    log "  Created: $SUCCESS"
    log "  Skipped: $SKIPPED"
    log "  Failed:  $FAILED"
}

# ============================================================
# GET LATEST WEEKLY SNAPSHOT
#
# Snapshot names contain:
#
#   weekly-YYYY-MM-DD-HHMMSS
#
# Because the timestamp format is lexicographically sortable,
# we can determine the newest snapshot without parsing ZFS's
# human-readable creation date.
# ============================================================

get_latest_weekly_snapshot() {

    zfs list -H -t snapshot -o name \
        | grep -E "^${POOL}/[^@]+@weekly-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}$" \
        | sort \
        | tail -n 1
}

# ============================================================
# DETERMINE WHETHER WEEKLY SNAPSHOT IS DUE
# ============================================================

weekly_snapshot_due() {

    local LATEST_WEEKLY
    local LATEST_TIMESTAMP
    local LATEST_EPOCH
    local CURRENT_EPOCH
    local AGE

    LATEST_WEEKLY=$(get_latest_weekly_snapshot)

    # --------------------------------------------------------
    # No weekly snapshot exists.
    # --------------------------------------------------------

    if [[ -z "$LATEST_WEEKLY" ]]; then
        log "No previous weekly snapshot found."
        return 0
    fi

    log "Latest weekly snapshot: $LATEST_WEEKLY"

    # --------------------------------------------------------
    # Extract timestamp from snapshot name.
    #
    # Example:
    # <YOUR_ZFS_POOL>/<DATASET>@weekly-2026-09-18-020000
    #
    # Extract:
    # 2026-09-18-020000
    # --------------------------------------------------------

    LATEST_TIMESTAMP="${LATEST_WEEKLY##*-}"

    # The above only gets HHMMSS because '-' is also used
    # inside the date. Extract the complete timestamp instead.
    LATEST_TIMESTAMP=$(echo "$LATEST_WEEKLY" \
        | sed -E 's/.*@weekly-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6})$/\1/')

    # --------------------------------------------------------
    # Validate timestamp format.
    # --------------------------------------------------------

    if [[ ! "$LATEST_TIMESTAMP" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}$ ]]; then
        log "WARNING: Unable to parse latest weekly snapshot timestamp."
        log "WARNING: Skipping weekly snapshot rather than making an unsafe assumption."
        return 1
    fi

    # --------------------------------------------------------
    # Convert timestamp to Unix epoch.
    # --------------------------------------------------------

    LATEST_EPOCH=$(date -d \
        "${LATEST_TIMESTAMP:0:10} ${LATEST_TIMESTAMP:11:2}:${LATEST_TIMESTAMP:13:2}:${LATEST_TIMESTAMP:15:2}" \
        '+%s' 2>/dev/null) || {

        log "WARNING: Unable to convert weekly snapshot timestamp."
        log "WARNING: Skipping weekly snapshot."
        return 1
    }

    CURRENT_EPOCH=$(date '+%s')

    AGE=$((CURRENT_EPOCH - LATEST_EPOCH))

    log "Age of latest weekly snapshot: $AGE seconds"
    log "Weekly interval: $WEEKLY_INTERVAL seconds"

    # --------------------------------------------------------
    # Weekly snapshot is due.
    # --------------------------------------------------------

    if (( AGE >= WEEKLY_INTERVAL )); then
        log "Weekly snapshot is due."
        return 0
    fi

    log "Weekly snapshot is not due yet."
    return 1
}

# ============================================================
# CLEANUP SNAPSHOTS
#
# Only snapshots matching this script's naming convention
# are considered for deletion.
# ============================================================

cleanup_snapshots() {

    local TYPE="$1"
    local RETENTION="$2"

    log "------------------------------------------------------------"
    log "Cleaning up $TYPE snapshots"
    log "Retention: $RETENTION"
    log "------------------------------------------------------------"

    for DATASET_NAME in "${DATASETS[@]}"; do

        DATASET="${POOL}/${DATASET_NAME}"

        # ----------------------------------------------------
        # Verify dataset exists
        # ----------------------------------------------------

        if ! dataset_exists "$DATASET"; then
            log "WARNING: Skipping cleanup for unavailable dataset: $DATASET"
            continue
        fi

        # ----------------------------------------------------
        # Get snapshots created by this script.
        #
        # Sort by the timestamp contained in the snapshot name.
        # ----------------------------------------------------

        SNAPSHOTS=$(zfs list -H -t snapshot -o name \
            | grep -E "^${DATASET}@${TYPE}-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}$" \
            | sort || true)

        if [[ -z "$SNAPSHOTS" ]]; then
            log "No $TYPE snapshots found for $DATASET"
            continue
        fi

        COUNT=$(echo "$SNAPSHOTS" | wc -l)

        log "$DATASET has $COUNT $TYPE snapshot(s)."

        # ----------------------------------------------------
        # Nothing to delete.
        # ----------------------------------------------------

        if (( COUNT <= RETENTION )); then
            log "No $TYPE snapshots need to be deleted."
            continue
        fi

        # ----------------------------------------------------
        # Determine how many old snapshots need deletion.
        # ----------------------------------------------------

        DELETE_COUNT=$((COUNT - RETENTION))

        log "Preparing to delete $DELETE_COUNT old $TYPE snapshot(s)."

        # ----------------------------------------------------
        # Delete oldest snapshots first.
        # ----------------------------------------------------

        echo "$SNAPSHOTS" \
            | head -n "$DELETE_COUNT" \
            | while read -r SNAPSHOT; do

                # Final safety check before destruction.
                if [[ "$SNAPSHOT" =~ ^${DATASET}@${TYPE}-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}$ ]]; then

                    if zfs destroy "$SNAPSHOT"; then
                        log "DELETED: $SNAPSHOT"
                    else
                        log "ERROR: Failed to delete $SNAPSHOT"
                    fi

                else
                    log "WARNING: Refusing to delete unexpected snapshot: $SNAPSHOT"
                fi

            done
    done
}

# ============================================================
# DAILY SNAPSHOTS
# ============================================================

log "============================================================"
log "DAILY SNAPSHOTS"
log "============================================================"

create_daily_snapshots

cleanup_snapshots "daily" "$DAILY_RETENTION"

# ============================================================
# WEEKLY SNAPSHOTS
# ============================================================

log "============================================================"
log "WEEKLY SNAPSHOTS"
log "============================================================"

if weekly_snapshot_due; then

    create_weekly_snapshots

    cleanup_snapshots "weekly" "$WEEKLY_RETENTION"

else

    log "Weekly snapshot not due. No weekly snapshots created."
fi

# ============================================================
# LOG CLEANUP
# ============================================================

log "============================================================"
log "LOG CLEANUP"
log "============================================================"

log "Removing log files older than 7 days."

find "$LOG_DIR" \
    -type f \
    -name 'zfs-snapshots-*.log' \
    -mtime +6 \
    -delete

log "Log cleanup complete."

# ============================================================
# FINISH
# ============================================================

log "============================================================"
log "ZFS snapshot job complete"
log "============================================================"
