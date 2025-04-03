#!/bin/bash

lat=12.3456 # Enter latitude
long=-12.3456 # Enter longitude
email="email@domain.tld" # Enter email for NOAA User-Agent
stack_base_path="/path/to/docker-compose-backups/alexandria" # Base path for Docker Compose stacks
stack_names=(stack1 stack2 stack3) # Docker compose stack names

poll_interval=3600 # Default polling interval (1 hour)
tornado_active=false

log_dir_base="/mnt/user/logs/weather_events"

log_event() {
    log_dir="${log_dir_base}/$(date '+%Y-%m-%d')"
    mkdir -p "$log_dir"
    log_file="${log_dir}/weather_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

cleanup_old_logs() {
    find "$log_dir_base" -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null # Note, \; marks the end of the -exec command
}

check_alerts() {
    message=$(curl -s "https://api.weather.gov/alerts/active?point=$lat,$long" -H "Accept: application/json" -H "User-Agent: Alexandria ($email)" | jq -r '.features[].properties.event // empty')
}

while true; do
    cleanup_old_logs  # Cleanup logs older than a month
    check_alerts

    if echo "$message" | grep -Eq "Tornado Warning|Tornado Emergency|Severe Thunderstorm Warning"; then
        if [ "$tornado_active" = false ]; then
            log_event "$message detected! Initiating emergency shutdown of servers."
            
            for stack_name in "${stack_names[@]}"; do
                log_event "Checking if $stack_name is running..."
                if docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" ps | grep -q 'Up'; then
                    log_event "Shutting down stack: $stack_name"
                    docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" down --remove-orphans >> "$log_dir/${stack_name}_shutdown.log" 2>&1
                else
                    log_event "Stack $stack_name is not running, skipping shutdown."
                fi
            done
            
            tornado_active=true
        fi
        poll_interval=60  # Continue polling every minute
    elif echo "$message" | grep -Eq "Tornado Watch|Severe Thunderstorm Watch"; then
        poll_interval=60  # Poll every minute
    else
        if [ "$tornado_active" = true ]; then
            log_event "No Tornado Warning detected, waiting 15 minutes before checking again..."
            sleep 900  # Wait 15 minutes
            check_alerts
            if ! echo "$message" | grep -Eq "Tornado Warning|Tornado Emergency"; then
                log_event "Tornado warning has cleared and 15 minutes have passed. Bringing stacks back up."
                
                for stack_name in "${stack_names[@]}"; do
                    log_event "Starting stack: $stack_name"
                    docker compose -f "$stack_base_path/${stack_name}/docker-compose.yml" up -d >> "$log_dir/${stack_name}_startup.log" 2>&1
                done

                tornado_active=false
                poll_interval=60 # Resume polling every minute after stacks are up
            fi
        elif ! echo "$message" | grep -Eq "Tornado Watch|Severe Thunderstorm Watch"; then
            log_event "No active severe weather watches. Resuming 1-hour polling."
            poll_interval=3600 # Resume 1-hour polling if no watches are present
        fi
    fi

    sleep "$poll_interval"
done
