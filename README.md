# Uptime Kuma WebDAV 备份工具

这是一个由社区开发的工具，用于将您的 Uptime Kuma 数据备份和还原到 WebDAV 服务器。

**重要声明：**
*   **这不是 Uptime Kuma 的官方仓库。** 这是一个由社区爱好者创建和维护的独立项目。
*   请自行承担使用此工具的风险。在执行还原操作前，强烈建议您先手动备份现有数据。
*   项目作者不对任何数据丢失或损坏负责。

## 先决条件

-   已安装并配置好 [rclone](https://rclone.org/)。
-   拥有一个可用的 WebDAV 服务器。

## 安装与配置

1.  克隆此仓库到您的服务器。
2.  为此仓库目录下的 `rclone.conf` 文件配置您的 WebDAV 远程存储信息。您可以参考 [rclone 官方文档](https://rclone.org/webdav/) 进行配置。
3.  (可选) 根据您的实际情况，修改 `backup.sh` 和 `restore.sh` 脚本中的 `UPTIME_KUMA_DATA_DIR` 默认路径。

## 使用方法

脚本可以直接运行，也可以接受一个路径参数来指定 Uptime Kuma 的数据目录。

-   **备份数据**
    -   使用默认路径：`./backup.sh`
    -   使用指定路径：`./backup.sh /path/to/your/uptime-kuma/data`

-   **还原数据**
    -   使用默认路径：`./restore.sh`
    -   使用指定路径：`./restore.sh /path/to/your/uptime-kuma/data`