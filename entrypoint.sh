#!/bin/bash

# =================================================================
# 动态创建 rclone 配置文件
# =================================================================
if [ -n "$RCLONE_CONF_BASE64" ]; then
  echo "正在从 RCLONE_CONF_BASE64 环境变量创建 rclone 配置文件..."
  # 确保配置目录存在
  mkdir -p /root/.config/rclone
  # 解码环境变量并写入配置文件
  echo "$RCLONE_CONF_BASE64" | base64 -d > /root/.config/rclone/rclone.conf
  echo "rclone.conf 文件已成功创建。"
else
  # 如果没有设置环境变量，备份将无法工作
  echo "警告：未找到 RCLONE_CONF_BASE64 环境变量。备份功能将无法使用。"
fi
# =================================================================

case "$1" in
  backup)
    exec /usr/local/bin/backup.sh
    ;;
  restore)
    exec /usr/local/bin/restore.sh
    ;;
  *)
    echo "Usage: {backup|restore}"
    exit 1
    ;;
esac