# 使用轻量级的 Alpine Linux 作为基础镜像
FROM alpine:latest

# 安装 rclone 所需的依赖
RUN apk add --no-cache curl unzip bash

# 下载并安装 rclone
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    mv rclone-*-linux-amd64/rclone /usr/bin/ && \
    rm -r rclone-* && \
    chmod 755 /usr/bin/rclone

# 复制脚本到 /usr/local/bin/
COPY backup.sh restore.sh entrypoint.sh /usr/local/bin/

# 赋予脚本执行权限并修复换行符
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/restore.sh /usr/local/bin/entrypoint.sh && \
    sed -i 's/\r$//' /usr/local/bin/backup.sh && \
    sed -i 's/\r$//' /usr/local/bin/restore.sh && \
    sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

# 设置容器的入口点
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
