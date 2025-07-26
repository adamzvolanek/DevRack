# Weather Alert Script for Alexandria

This script is designed for **Alexandria** (server) to enter a *precautionary* critical-services-only state in the event of severe weather by monitoring NOAA alerts and responding accordingly.

## Description

This script continuously monitors NOAA weather alerts for **Tornado Warnings**, **Tornado Emergencies**, and **Severe Thunderstorm Warnings or Watches**. Based on alert types, it manages Docker Compose stacks and logs weather events with timestamps.

1. **Polls NOAA every hour** for active weather alerts at a specified location (latitude and longitude).
2. If a **Tornado Watch** or **Severe Thunderstorm Watch** is detected:
   - Switches to **polling every minute** for updates.
3. If a **Tornado Warning**, **Tornado Emergency**, or **Severe Thunderstorm Warning** is detected:
   - Logs the alert.
   - **Shuts down specified Docker Compose stacks**.
   - Continues **polling every minute** until cleared.
4. Once the warning is cleared **and 15 minutes have passed**:
   - **Restarts the previously shut down Docker stacks**.
   - Continues **1-minute polling** to monitor for new alerts.
5. If **watches** are cleared and no warnings remain:
   - **Polling returns to every hour**.
6. Logs a **heartbeat message every minute** during high-alert states (1-minute polling), including timestamp and current alerts.
7. Logs all events to `/mnt/user/logs/weather_events/YYYY-MM-DD/`, organized by date.
8. **Automatically deletes logs older than 30 days**.
9. All logs and folders are created with **`777` permissions** for full accessibility.
10. If NOAA API requests fail, the script **retries 3 times** with a **5-second delay** between attempts before logging an error and proceeding with an empty message.

## Variables

| Variable           | Description |
|--------------------|-------------|
| `lat`              | Latitude of the monitored location. Used in NOAA API queries. |
| `long`             | Longitude of the monitored location. |
| `email`            | Email used as User-Agent for NOAA API requests. Required by NOAA for contact purposes. |
| `stack_base_path`  | Base directory for Docker Compose stack folders. Each subfolder contains its own `docker-compose.yml`. |
| `stack_names`      | An array of Docker Compose stack names to control during alerts. |
| `poll_interval`    | Current polling frequency in seconds. Dynamically adjusted (default: 3600 seconds / 1 hour). |
| `tornado_active`   | Boolean flag tracking whether a Tornado Warning or Emergency is currently active. |
| `log_dir_base`     | Base path for all log files. Logs are organized in daily subdirectories. |

---

## Functions

- **`log_event()`**
  - Logs a message with a timestamp.
  - Ensures daily log directory exists and has `777` permissions.

- **`cleanup_old_logs()`**
  - Removes any weather event logs older than 30 days.

- **`check_alerts()`**
  - Queries NOAA API for current weather alerts.
  - Retries up to 3 times on failure (5-second delay between tries).
  - Extracts alert messages for downstream decisions.

- **`format_message_inline()`**
  - Converts multi-line NOAA alert list into a comma-separated, inline string.
  - Used in heartbeat and alert logs for readability.

## Logging Behavior

- Logs are stored under: `/mnt/user/logs/weather_events/YYYY-MM-DD/`
- File types include:
  - `weather_log.txt` → general daily log
  - `stackname_shutdown.log` → per-stack shutdown details
  - `stackname_startup.log` → per-stack startup details
- All log files and folders are created with `777` permissions.
- **Heartbeat example (every minute during 60s polling):**

- ```text
  2025-04-03 21:34:16 - Polling every 60 seconds - Current alerts: Severe Thunderstorm Warning, Flash Flood Warning
