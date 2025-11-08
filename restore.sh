#!/bin/bash

# rclone 远程配置名称
RCLONE_REMOTE="my-webdav"

# Uptime Kuma 数据目录的默认路径
# 如果脚本后面没有提供参数，则使用此路径
DEFAULT_UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# 检查是否提供了路径参数，否则使用默认路径
UPTIME_KUMA_DATA_DIR=${1:-$DEFAULT_UPTIME_KUMA_DATA_DIR}

echo "正在从 WebDAV 还原 Uptime Kuma 数据..."
echo "源远程: $RCLONE_REMOTE:uptime-kuma-backup"
echo "目标目录: $UPTIME_KUMA_DATA_DIR"
echo "警告：此操作将覆盖目标目录中的现有文件！"

# 在继续之前暂停5秒，给用户取消的机会
sleep 5

# 执行同步还原
rclone sync -P "$RCLONE_REMOTE:uptime-kuma-backup" "$UPTIME_KUMA_DATA_DIR"

echo "还原完成！"