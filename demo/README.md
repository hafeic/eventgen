# Eventgen Local File Output Demo

这个 Demo 演示了如何使用 Splunk Eventgen 在本地生成模拟日志，并将其直接输出到指定的本地文件夹中。同时它也演示了如何随机生成不同级别的日志（如 ERROR, INFO, WARN）和不同的消息内容。

## 目录结构

- `demo/samples/demo.sample`: 包含要生成的日志的原始样本模板。文件内使用 `[LOG_LEVEL]` 和 `[LOG_MESSAGE]` 作为需要动态替换的占位符。
- `demo/eventgen.conf`: Eventgen 的配置文件。它指定了输入样本、生成模式、日志时间以及其他自定义字段的替换规则，并将 `outputMode` 配置为 `file`，指定输出文件到 `demo/logs/output.log`。
- `run_demo.sh`: 用于运行这个演示的 Bash 脚本。它将创建目标文件夹并启动日志生成。

## 配置详解 (`eventgen.conf`)

在 `demo/eventgen.conf` 中，我们主要做了如下配置：

```ini
[demo.sample]
sampleDir = demo/samples
# mode 指定了以 sample 模式进行
mode = sample
sampletype = raw

# 下面两行是最关键的：将输出模式设置为 file，并指定输出的文件路径
outputMode = file
fileName = demo/logs/output.log

# 指定生成的频率和数量：每 5 秒运行一次，每次生成 10 条日志
interval = 5
count = 10
earliest = -10m
latest = now

# Token 0: 将 demo.sample 里的静态时间戳替换为当前生成的时间
token.0.token = \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}
token.0.replacementType = timestamp
token.0.replacement = %Y-%m-%d %H:%M:%S

# Token 1: 将日志中的 [LOG_LEVEL] 随机替换为列表中的某个日志级别
token.1.token = \[LOG_LEVEL\]
token.1.replacementType = random
token.1.replacement = list["INFO", "WARN", "ERROR", "DEBUG"]

# Token 2: 将日志中的 [LOG_MESSAGE] 随机替换为列表中的某条日志信息
token.2.token = \[LOG_MESSAGE\]
token.2.replacementType = random
token.2.replacement = list["User login successful", "Database connection timeout", "Failed to parse request payload", "Service started successfully", "Disk usage exceeded 80%", "Authentication failed for user admin"]
```

## 扩展建议

如果你的日志信息（Log Message）很多，不想全部写在 `eventgen.conf` 中，也可以使用文件的方式来替换，比如：
1. 将 `replacementType` 修改为 `file`
2. 将 `replacement` 设置为指定文件的路径（例如：`demo/samples/messages.txt`），Eventgen 就会自动从该文件中随机读取一行来替换。

## 如何运行

请确保你已经安装了 `poetry` 并且处于正确的 Python 环境中 (Python 3.7+)。
*注意：本仓库代码依赖较老版本的 Python 内置库（例如 `imp`），请使用 Python 3.7 - 3.11 版本，Python 3.12 及以上版本会报错。*

1. 安装依赖 (如果还未安装)：
   ```bash
   poetry install
   ```
2. 在项目根目录下，给脚本增加执行权限：
   ```bash
   chmod +x run_demo.sh
   ```
3. 运行演示脚本：
   ```bash
   ./run_demo.sh
   ```

运行后，Eventgen 会开始执行。你可以在另一个终端窗口中查看正在生成的日志内容：

```bash
tail -f demo/logs/output.log
```

你会看到类似这样的多样化输出：
```
2023-10-25 10:15:30 INFO - Service started successfully
2023-10-25 10:15:30 ERROR - Database connection timeout
2023-10-25 10:15:30 WARN - Disk usage exceeded 80%
```

你可以随时按 `Ctrl + C` 来停止日志生成。
