# Uptime Kuma WebDAV Backup

This tool allows you to backup and restore your Uptime Kuma data to a WebDAV server.

## Prerequisites

- [rclone](httpshttps://rclone.org/) installed and configured.
- A WebDAV server.

## Setup

1.  Clone this repository.
2.  Create a new rclone remote for your WebDAV server. You can follow the [rclone documentation](https://rclone.org/webdav/) for instructions.
3.  Copy your `rclone.conf` to this directory.
4.  Edit `backup.sh` and `restore.sh` to set the correct values for `RCLONE_REMOTE` and `UPTIME_KUMA_DATA_DIR`.

## Usage

-   To create a backup, run `./backup.sh`.
-   To restore a backup, run `./restore.sh`.
