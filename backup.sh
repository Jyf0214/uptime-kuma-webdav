#!/bin/bash

# rclone 远程配置名称
RCLONE_REMOTE="my-webdav"

# Uptime Kuma 数据目录的默认路径
# 如果脚本后面没有提供参数，则使用此路径
DEFAULT_UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# 检查是否提供了路径参数，否则使用默认路径
UPTIME_KUMA_DATA_DIR=${1:-$DEFAULT_UPTIME_KUMA_DATA_DIR}

echo "正在备份 Uptime Kuma 数据..."
echo "源目录: $UPTIME_KUMA_DATA_DIR"
echo "目标远程: $RCLONE_REMOTE:uptime-kuma-backup"

# 执行同步备份
rclone sync -P "$UPTIME_KUMA_DATA_DIR" "$RCLONE_REMOTE:uptime-kuma-backup"

echo "备份完成！"