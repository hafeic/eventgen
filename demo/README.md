# Eventgen Local File Output Demo

这个 Demo 演示了如何使用 Splunk Eventgen 在本地生成模拟日志，并将其直接输出到指定的本地文件夹中。

## 目录结构

- `demo/samples/demo.sample`: 包含要生成的日志的原始样本。我们在这里放置了一行带有时间戳的通用日志内容。
- `demo/eventgen.conf`: Eventgen 的配置文件。它指定了输入样本、生成模式、日志时间替换规则，并将 `outputMode` 配置为 `file`，指定输出文件到 `demo/logs/output.log`。
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

# 指定生成的频率和数量：每 5 秒运行一次，每次生成 2 条日志
interval = 5
count = 2
earliest = -10m
latest = now

# Token 替换规则：将 demo.sample 里的静态时间戳替换为当前生成的时间
token.0.token = \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}
token.0.replacementType = timestamp
token.0.replacement = %Y-%m-%d %H:%M:%S
```

## 如何运行

请确保你已经安装了 `poetry` 并且处于正确的 Python 环境中 (Python 3.7+)。

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

你可以随时按 `Ctrl + C` 来停止日志生成。
