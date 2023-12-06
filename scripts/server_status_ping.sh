#!/bin/bash
echo "Pinging Health Check Endpoint"

# using curl (10 second timeout, retry up to 5 times):
curl -m 10 --retry 5 https://hc-ping.com/{ping_key}/alexandria

