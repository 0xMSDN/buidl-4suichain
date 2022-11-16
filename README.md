# 使用模板在Azure中部署Sui Chain

## 1、Terraform 

模板使用AzureRM Provider部署Azure VM。
在虚拟机部署完成之后需要等待初始化脚本运行完毕，大约需要5分钟。
可以验证 `Docker` 和 `Docker-Compose` 命令。

初始化脚本完成之后，可以在 `/home/ubuntu` 目录中找到 `sui` 目录。
目录中有两个文件：
1、fullnode-template.yaml
2、genesis.blob

通过 `docker-compose up` 快速启动