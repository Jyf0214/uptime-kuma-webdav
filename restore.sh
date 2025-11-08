#!/bin/bash

# rclone 远程配置名称
RCLONE_REMOTE="my-webdav"

# Uptime Kuma 数据目录的默认路径
DEFAULT_UPTIME_KUMA_DATA_DIR="/opt/uptime-kuma/data"

# 临时 rclone 配置文件的路径
RCLONE_CONFIG_FILE=$(mktemp)

# 设置一个陷阱，确保脚本退出时（无论成功或失败）都删除临时文件
trap 'rm -f "$RCLONE_CONFIG_FILE"' EXIT

# 默认的 rclone 命令行参数
RCLONE_OPTS=""

# 检查是否存在 Base64 编码的配置环境变量
if [ -n "$RCLONE_CONF_BASE64" ]; then
  # 解码环境变量内容并写入临时文件
  echo "$RCLONE_CONF_BASE64" | base64 -d > "$RCLONE_CONFIG_FILE"
  # 更新 rclone 参数以使用临时配置文件
  RCLONE_OPTS="--config=$RCLONE_CONFIG_FILE"
  echo "检测到环境变量配置，将使用临时配置文件。"
else
  # 如果环境变量不存在，则使用当前目录的 rclone.conf
  RCLONE_OPTS="--config=./rclone.conf"
  echo "未检测到环境变量配置，将使用本地 rclone.conf 文件。"
fi

# 辅助函数：仅在非HF环境或DEBUG模式下打印日志
log_verbose() {
  # 检查 SPACE_ID 是否未设置 (非HF环境) 或 DEBUG 是否已设置
  if [ -z "$SPACE_ID" ] || [ -n "$DEBUG" ]; then
    echo "$@"
  fi
}

# 检查是否提供了路径参数，否则使用默认路径
UPTIME_KUMA_DATA_DIR=${1:-$DEFAULT_UPTIME_KUMA_DATA_DIR}

log_verbose "正在从 WebDAV 还原 Uptime Kuma 数据..."
log_verbose "源远程: $RCLONE_REMOTE:uptime-kuma-backup"
log_verbose "目标目录: $UPTIME_KUMA_DATA_DIR"

# 警告信息始终显示
echo "警告：此操作将覆盖目标目录中的现有文件！"
log_verbose "操作将在5秒后继续..."

# 在继续之前暂停5秒，给用户取消的机会
sleep 5

# 执行同步还原
# 在HF环境中，添加 --quiet 标志以减少rclone自身的输出
if [ -n "$SPACE_ID" ] && [ -z "$DEBUG" ]; then
  rclone sync --quiet -P "$RCLONE_REMOTE:uptime-kuma-backup" "$UPTIME_KUMA_DATA_DIR" $RCLONE_OPTS
else
  rclone sync -P "$RCLONE_REMOTE:uptime-kuma-backup" "$UPTIME_KUMA_DATA_DIR" $RCLONE_OPTS
fi

echo "还原完成！"
