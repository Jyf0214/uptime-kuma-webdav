# Uptime Kuma WebDAV 备份工具

这是一个由社区开发的工具，用于将您的 Uptime Kuma 数据备份和还原到 WebDAV 服务器。

**重要声明：**
*   **这不是 Uptime Kuma 的官方仓库。** 这是一个由社区爱好者创建和维护的独立项目。
*   请自行承担使用此工具的风险。在执行还原操作前，强烈建议您先手动备份现有数据。
*   项目作者不对任何数据丢失或损坏负责。

## 先决条件

-   已安装并配置好 [rclone](https://rclone.org/)。
-   拥有一个可用的 WebDAV 服务器。

## 配置方法

您有两种方式来为本工具提供 rclone 配置：

### 方法一：使用 `rclone.conf` 文件 (本地使用)

1.  克隆此仓库到您的服务器。
2.  将您配置好的 `rclone.conf` 文件放入此仓库的根目录。您可以参考 [rclone 官方文档](https://rclone.org/webdav/) 进行配置。
3.  (可选) 根据您的实际情况，修改 `backup.sh` 和 `restore.sh` 脚本中的 `UPTIME_KUMA_DATA_DIR` 默认路径。

### 方法二：使用环境变量 (推荐用于 Hugging Face 等环境)

为了提高安全性，您可以将 `rclone.conf` 文件的内容通过环境变量传递给脚本。

1.  **生成 Base64 字符串**:
    在您的本地计算机上，运行以下命令来转换您的 `rclone.conf` 文件：
    ```bash
    cat /path/to/your/rclone.conf | base64
    ```
    复制生成的长字符串。

2.  **设置环境变量**:
    在您的部署环境 (例如 Hugging Face Spaces 的 Secrets) 中，创建一个名为 `RCLONE_CONF_BASE64` 的环境变量，并将上一步复制的字符串粘贴为其值。

    脚本在运行时会自动检测到这个变量，解码并使用其中的配置。

## 使用方法

脚本可以直接运行，也可以接受一个路径参数来指定 Uptime Kuma 的数据目录。

-   **备份数据**
    -   使用默认路径：`./backup.sh`
    -   使用指定路径：`./backup.sh /path/to/your/uptime-kuma/data`

-   **还原数据**
    -   使用默认路径：`./restore.sh`
    -   使用指定路径：`./restore.sh /path/to/your/uptime-kuma/data`

## 日志输出

为了适应不同的运行环境，脚本的日志输出行为是可控的：

-   **默认行为**：在标准环境（非 Hugging Face）中，脚本会输出详细的操作信息。
-   **静默行为**：当检测到在 Hugging Face Spaces 环境中运行时，脚本将自动进入静默模式，只在操作完成后输出最终结果。
-   **强制启用详细日志**：如果您需要查看详细日志以进行调试，可以在运行脚本时设置 `DEBUG` 环境变量。
    ```bash
    # 示例：在任何环境下强制输出详细日志
    DEBUG=true ./backup.sh
    ```
