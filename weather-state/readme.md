# Directory for Weather Alert Script

This is supposed to cover creating a query script for Alexandria (server) to enter a 'precautionary' critical-services only state in the event of severe weather.

## Description

Script monitors NOAA weather alerts for tornado warnings, tornado emergencies, and severe weather watches. It performs the following tasks:

1. **Polls NOAA every hour** for active weather alerts at a specified location (latitude and longitude).
2. If a **Tornado Watch** or **Severe Thunderstorm Watch** is detected:
   - **Polls every minute** for updates on the watch status.
3. If a **Tornado Warning or Emergency** is detected:
   - **Shuts down specified Docker Compose stacks**.
   - **Polls every minute** until the warning is cleared.
4. Once the **Tornado Warning or Emergency** clears and 15 minutes have passed:
   - **Brings Docker stacks back online**.
   - **Resumes polling every minute** for further weather alerts.
5. If the **Tornado Watch** or **Severe Thunderstorm Watch** is cleared, the script:
   - **Resumes polling every hour**.
6. **Logs all actions** (stack shutdown, startup, weather alerts) in a log directory under `/mnt/user/logs/weather_events/`, including automatic cleanup of logs older than 30 days.

### Variables and Their Roles

- **`lat`**  
  The **latitude** of the server or location to monitor weather alerts for. This is used in the NOAA API query.

- **`long`**  
  The **longitude** of the server or location to monitor weather alerts for. This is used in the NOAA API query.

- **`email`**  
  The email address used as a **User-Agent** in the NOAA API request. This helps identify the requester when accessing the weather alerts.

- **`stack_base_path`**  
  The base directory where the **Docker Compose stacks** are stored. Each stack's directory contains its own `docker-compose.yml` file. This path is used when bringing stacks down or up.

- **`stack_names`**  
  An array of **Docker Compose stack names**. The script will loop through these names and bring the corresponding stacks down or up based on weather alerts.

- **`poll_interval`**  
  The **polling interval** in seconds. The script will check NOAA for weather alerts at this interval (default is 1 hour). This can be dynamically changed to 1 minute or 15 minutes based on the weather conditions.

- **`tornado_active`**  
  A boolean flag that tracks whether a **tornado warning** or **emergency** is active. This controls whether the script takes actions such as shutting down or bringing up Docker stacks.

- **`log_dir_base`**  
  The **base directory** where the script will store logs. The logs include weather event details, stack shutdowns, and startups, all organized by date.

### Functions

- **`log_event()`**  
  A function that logs messages with timestamps to a log file located in the appropriate date-based directory under `/mnt/user/logs/weather_events/`.

- **`cleanup_old_logs()`**  
  A function that **removes logs** older than 30 days from the `/mnt/user/logs/weather_events/` directory to keep storage clean.

- **`check_alerts()`**  
  A function that **fetches active weather alerts** from the NOAA API based on the given latitude and longitude, storing the alerts in the `message` variable.
