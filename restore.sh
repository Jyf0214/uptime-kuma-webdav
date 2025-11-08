#!/bin/bash

# Configuration
RCLONE_REMOTE="my-webdav"
UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# Restore
rclone sync -P "$RCLONE_REMOTE:uptime-kuma-backup" "$UPTIME_KUMA_DATA_DIR"
