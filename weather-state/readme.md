# Directory for Weather Alert Script

This is supposed to cover creating a query script for Alexandria (server) to enter a 'precautionary' critical-services only state in the event of severe weather.

A script will run a cron job 1/hr polling NOAA for alerts at my servers lat/long.

If a tornado watch or severe thunderstorm watch is issued, the cron query will poll once every 1/minute.

If a tornado warning or emergency is issued, bring down all `stack_name`'s. Continue to poll at 1/minute until tornado warning or emergency. If alert is no longer present, wait 15 minutes before querying again. Docker `stack_name`'s remain off and another 15 minute waiting period continues.

If no active alerts are present after a 15 minute period of no tornado warning (or tornado emergency), return to polling 1/minute. If no tornado watch or severe thunderstorm watch is removed. Return to polling 1/hr.
