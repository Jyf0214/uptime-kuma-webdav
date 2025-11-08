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
  echo "警告：未找到 RCLONE_CONF_BASE64 环境变量。自动备份功能将无法使用。"
fi
# =================================================================

# Uptime Kuma 数据目录的默认路径
UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# 确保 Uptime Kuma 数据目录存在，否则 inotifywait 会失败
mkdir -p "$UPTIME_KUMA_DATA_DIR"

# 执行一次初始备份
echo "执行初始备份..."
/usr/local/bin/backup.sh "$UPTIME_KUMA_DATA_DIR" &

# 启动文件变更监控
echo "启动文件变更监控..."
while true; do
  # 监控 Uptime Kuma 数据目录的修改、创建、删除、移动事件
  inotifywait -rq -e modify,create,delete,move "$UPTIME_KUMA_DATA_DIR"

  echo "检测到文件变更，将在10秒后开始备份..."
  sleep 10
  
  # 调用备份脚本
  /usr/local/bin/backup.sh "$UPTIME_KUMA_DATA_DIR" &
done &

# 保持容器运行
echo "容器服务已启动，保持运行..."
tail -f /dev/null
