# Directory for Weather Alert Script

This script is designed for Alexandria (server) to enter a 'precautionary' critical-services-only state in the event of severe weather by monitoring NOAA alerts and responding accordingly.

## Description

This script continuously monitors NOAA weather alerts for tornado warnings, emergencies, and severe weather watches. Based on alert types, it manages Docker Compose stacks and logs weather events with timestamps. Key behavior includes:

1. Polls NOAA every hour for active weather alerts at a specified location (latitude and longitude).
2. If a Tornado Watch or Severe Thunderstorm Watch is detected:
   - **Polls every minute** for updates on the watch status.
3. If a Tornado Warning or Tornado Emergency is detected:
   - Logs the alert and shuts down specified Docker Compose stacks.
   - **Polls every minute** until the warning clears.
4. Once the Tornado Warning or Emergency clears **and 15 minutes have passed**:
   - Brings Docker stacks back online.
   - **Continues polling every minute** to catch possible reoccurrences.
5. If the Tornado Watch or Severe Thunderstorm Watch is cleared:
   - **Resumes polling every hour**.
6. A heartbeat message is logged every minute during 1-minute polling intervals, including a timestamp and inline list of current alerts.
7. Logs all actions (e.g. stack shutdowns, startups, and NOAA alerts) in a date-based directory under `/mnt/user/logs/weather_events/`.
8. Automatically removes logs older than 30 days to maintain a clean log directory.
9. All logs and folders are created with `777` permissions to ensure full accessibility.

## Variables and Their Roles

| Variable         | Description |
|------------------|-------------|
| `lat`            | Latitude of the monitored location. Used in NOAA API queries. |
| `long`           | Longitude of the monitored location. |
| `email`          | Email used as User-Agent for NOAA API requests. Required by NOAA for contact purposes. |
| `stack_base_path`| Base directory for Docker Compose stack folders. Each subfolder contains its own `docker-compose.yml`. |
| `stack_names`    | An array of Docker Compose stack names to be controlled during alerts. |
| `poll_interval`  | Current polling frequency in seconds. Adjusted dynamically (default: 3600 seconds / 1 hour). |
| `tornado_active` | Boolean flag tracking whether a Tornado Warning or Emergency is active. |
| `log_dir_base`   | Base path for all log files. Logs are stored by date in this directory. |

## Functions

- **`log_event()`**
  - Appends messages with timestamps to a daily log file.
  - Ensures the log directory and file exist with full `777` permissions.
  
- **`cleanup_old_logs()`**
  - Deletes any weather event logs older than 30 days.

- **`check_alerts()`**
  - Queries NOAA for current weather alerts at the specified location.
  - Stores and formats the results for decision-making and logging.

- **`format_message_inline()`**
  - Converts multi-line weather alert messages into a comma-separated, single-line format for cleaner logs and heartbeat messages.
  - Handles single or multiple alerts cleanly without breaking log formatting.

## Logging Behavior

- Logs are saved under `/mnt/user/logs/weather_events/YYYY-MM-DD/`.
- Each day gets its own folder and log files, including:
  - General weather log: `weather_log.txt`
  - Stack-specific logs for shutdown/startup (e.g., `stack1_shutdown.log`, `stack1_startup.log`)
- Log folders and files have `777` permissions.
- Every minute (if in a high-alert state), a heartbeat is logged:

  ```text
  2025-04-03 21:34:16 - Heartbeat: Polling every 60 seconds - Current alerts: Severe Thunderstorm Warning, Flash Flood Warning
