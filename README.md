[![Page Views Count](https://badges.toozhao.com/badges/01GSH8K8HVP0RX6M7GD08D5YBP/green.svg)](https://badges.toozhao.com/stats/01GSH8K8HVP0RX6M7GD08D5YBP "View Count")


# 使用模板在Azure中部署Sui Chain

*目前Sui Chain只有Fullnode节点类型。<br> validator节点的申请链接是 `https://bit.ly/sui_validator` <br> 但从8月15日开始已经不再接受新的申请*

模板分成两部分：<br>1、Terraform<br>2、Azure Template<br>

---


## 1、Terraform 

模板使用AzureRM Provider部署Azure VM。 <br>在虚拟机部署完成之后需要等待初始化脚本运行完毕，大约需要5分钟。 <br>可以验证 `Docker` 和 `Docker-Compose` 命令。 <br> (请确保在执行前安装Azure CLI，并执行 `Az login`) <br>

## 2、Azure Template

模板使用 `Deploy to Azure` 一键部署 <br>部署完成后即可直接通过用户名密码登录 <br>可以验证 `Docker` 和 `Docker-Compose` 命令。 <br>  

参数说明: <br>1、创建/选择资源组 <br>2、选择区域 <br>3、填写Admin Password <br>4、其他保持默认 <br>

---

登录VM之后可以在 `/home/ubuntu` 目录中找到 `sui` 目录。 <br>目录中有三个文件：<br>1、docker-compose.yaml <br>2、fullnode-template.yaml <br>3、genesis.blob <br>

通过 `docker-compose up` 快速启动 <br>

---

启动成功后可以看到：
![start](ARM/pictures/start.png)

在浏览器中输入 `http://<your ip address>:9184/metrics` 可以看到：
![metrics](ARM/pictures/metrics.png)

检查 RPC 端口是否打开并正常工作，从终端运行以下命令（替换自己的IP地址）
~~~ shell
curl --location --request POST <your IP address>:9000 \
--header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}'
~~~

可以看到：
![rpc](ARM/pictures/rpc.png)

检查节点的同步状态: <br>要检查您的节点的当前同步状态，您可以从此处使用 Sui 节点检查器 `https://bit.ly/sui_validator`。<br>只需输入您的节点 IP 并单击“检查”，它就会告诉您到目前为止，您的节点已索引的交易百分比
![check](ARM/pictures/check.png)

---
**<p>我们是微软CSI（Micorosft China Strategic Incubator）团队，目前微软有孵化Startup项目的计划，如果大家有好的项目或者问题欢迎随时来跟我们聊一聊，我们很希望能和社区的开发者们一起探讨web3的新技术以及未来的发展方向，如果有机会合作并加入微软孵化计划还有免费的资源可以使用</p>**

**<p>联系邮箱：xiaopingfeng@microsoft.com</p>**