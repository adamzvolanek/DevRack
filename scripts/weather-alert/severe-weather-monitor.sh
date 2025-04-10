#!/bin/bash

lat=12.3456 # Enter latitude
long=-12.3456 # Enter longitude
email="email@domain.tld" # Enter email for NOAA User-Agent
stack_base_path="/path/to/docker-compose-backups/alexandria" # Base path for Docker Compose stacks
stack_names=(stack1 stack2) # Docker compose stack names

poll_interval=3600 # Default polling interval (1 hour)
tornado_active=false

log_dir_base="/mnt/user/logs/weather_events"

log_event() {
    log_dir="${log_dir_base}/$(date '+%Y-%m-%d')"
    mkdir -p "$log_dir"
    chmod 777 "$log_dir"
    log_file="${log_dir}/weather_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

format_message_inline() {
    echo "$1" | paste -sd ", " -
}

cleanup_old_logs() {
    find "$log_dir_base" -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null
}

check_alerts() {
    local retries=3
    local delay=5
    local attempt=1
    local response=""

    while [ $attempt -le $retries ]; do
        response=$(curl -s "https://api.weather.gov/alerts/active?point=$lat,$long" \
            -H "Accept: application/json" \
            -H "User-Agent: Alexandria ($email)")
        
        if [ -n "$response" ]; then
            message=$(echo "$response" | jq -r '.features[].properties.event // empty')
            return
        else
            log_event "Attempt $attempt: Failed to fetch weather alerts. Retrying in $delay seconds..."
            sleep $delay
            attempt=$((attempt + 1))
        fi
    done

    log_event "All attempts to fetch NOAA alerts failed. Using empty message."
    message=""
}

while true; do
    cleanup_old_logs
    check_alerts

    if echo "$message" | grep -Eiq "Tornado Warning|Tornado Emergency|Severe Thunderstorm Warning"; then
        if [ "$tornado_active" = false ]; then
            message_inline=$(format_message_inline "$message")
            log_event "${message_inline:-No alerts} detected! Shutting down stacks: ${stack_names[*]}"

            for stack_name in "${stack_names[@]}"; do
                log_event "[$(date '+%Y-%m-%d %H:%M:%S')] Checking if $stack_name is running..."
                if docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" ps | grep -q 'Up'; then
                    log_event "[$(date '+%Y-%m-%d %H:%M:%S')] Shutting down stack: $stack_name"
                    docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" down --remove-orphans >> "$log_dir/${stack_name}_shutdown.log" 2>&1
                else
                    log_event "[$(date '+%Y-%m-%d %H:%M:%S')] Stack $stack_name is not running, skipping shutdown."
                fi
            done

            tornado_active=true
        fi
        poll_interval=60
    elif echo "$message" | grep -Eq "Tornado Watch|Severe Thunderstorm Watch"; then
        poll_interval=60
    else
        if [ "$tornado_active" = true ]; then
            log_event "No Tornado Warning detected, waiting 15 minutes before checking again..."
            sleep 900
            check_alerts
            if ! echo "$message" | grep -Eiq "Tornado Warning|Tornado Emergency|Severe Thunderstorm Warning"; then
                log_event "Tornado warning has cleared and 15 minutes have passed. Bringing stacks back up."

                for stack_name in "${stack_names[@]}"; do
                    log_event "[$(date '+%Y-%m-%d %H:%M:%S')] Starting stack: $stack_name"
                    docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" up -d >> "$log_dir/${stack_name}_startup.log" 2>&1
                done

                tornado_active=false
                poll_interval=60
            fi
        elif ! echo "$message" | grep -Eiq "Tornado Watch|Severe Thunderstorm Watch"; then
            log_event "No active severe weather watches. Resuming 1-hour polling."
            poll_interval=3600
        fi
    fi

    # Heartbeat
    if [ "$poll_interval" -eq 60 ]; then
        message_inline=$(format_message_inline "$message")
        log_event "Polling every 60 seconds - Current alerts: ${message_inline:-None}"
    fi

    sleep "$poll_interval"
done
