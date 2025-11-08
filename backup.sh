#!/bin/bash

# Configuration
RCLONE_REMOTE="my-webdav"
UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# Backup
rclone sync -P "$UPTIME_KUMA_DATA_DIR" "$RCLONE_REMOTE:uptime-kuma-backup"
