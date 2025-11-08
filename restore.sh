#!/bin/bash

# =================================================================
# Uptime Kuma 数据还原脚本
# =================================================================
# 本脚本使用 rclone 进行数据还原。rclone 配置由 entrypoint.sh 动态处理。
# =================================================================

# --- 配置 ---

# 从环境变量读取远程路径，如果未设置则使用默认值
RCLONE_REMOTE_PATH=${RCLONE_REMOTE_PATH:-"my-webdav:uptime-kuma-backup"}
# Uptime Kuma 数据目录的默认路径
UPTIME_KUMA_DATA_DIR=${1:-"/opt/uptime-kuma/data"}

# --- 辅助函数 ---

# 仅在 DEBUG 模式下打印日志
log_debug() {
  if [ -n "$DEBUG" ]; then
    echo "$@"
  fi
}

# --- 主要还原逻辑 ---

log_debug "----------------------------------------"
log_debug "DEBUG 模式：开始从 WebDAV 还原 Uptime Kuma 数据"
log_debug "源远程: $RCLONE_REMOTE_PATH"
log_debug "目标目录: $UPTIME_KUMA_DATA_DIR"
log_debug "时间: $(date)"
log_debug "----------------------------------------"

# 警告信息始终显示
echo "警告：此操作将覆盖目标目录中的现有文件！"
log_debug "操作将在5秒后继续..."

# 在继续之前暂停5秒，给用户取消的机会
sleep 5

# 检查 rclone 配置是否正确
if ! rclone listremotes >/dev/null 2>&1; then
  echo "错误：rclone 配置不正确或不存在。请检查 RCLONE_CONF_BASE64 环境变量。" >&2
  exit 1
fi

# 执行同步还原
# 在 HF 环境中，如果未设置 DEBUG，则添加 --quiet 标志以减少 rclone 自身的输出
if [ -n "$SPACE_ID" ] && [ -z "$DEBUG" ]; then
  rclone sync --quiet -P "$RCLONE_REMOTE_PATH" "$UPTIME_KUMA_DATA_DIR"
  rc_status=$?
elif [ -n "$DEBUG" ]; then
  rclone sync -P "$RCLONE_REMOTE_PATH" "$UPTIME_KUMA_DATA_DIR" --verbose --transfers 4
  rc_status=$?
else
  rclone sync -P "$RCLONE_REMOTE_PATH" "$UPTIME_KUMA_DATA_DIR"
  rc_status=$?
fi

# --- 日志输出 ---

if [ $rc_status -eq 0 ]; then
  if [ -n "$DEBUG" ]; then
    echo "还原成功！"
    echo "----------------------------------------"
    echo "还原完成。"
    echo "----------------------------------------"
  else
    echo "还原完成！"
  fi
else
  echo "还原失败！请检查 rclone 配置和日志。" >&2
fi