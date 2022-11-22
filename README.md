# 使用模板在Azure中部署Sui Chain

模板分成两部分：<br>
1、Terraform<br>
2、Azure Template<br>

---


## 1、Terraform 

模板使用AzureRM Provider部署Azure VM。 <br>
在虚拟机部署完成之后需要等待初始化脚本运行完毕，大约需要5分钟。 <br>
可以验证 `Docker` 和 `Docker-Compose` 命令。 <br> 
(请确保在执行前安装Azure CLI，并执行 `Az login`) <br>
<br>

## 2、Azure Template

模板使用 `Deploy to Azure` 一键部署 <br>
部署完成后即可直接通过用户名密码登录 <br>
可以验证 `Docker` 和 `Docker-Compose` 命令。 <br>  
<br>

参数说明: <br>

1、创建/选择资源组 <br>
2、选择区域 <br>
3、填写Admin Password <br>
4、其他保持默认 <br>


---

登录VM之后可以在 `/home/ubuntu` 目录中找到 `sui` 目录。 <br>
目录中有三个文件：<br>
1、docker-compose.yaml <br>
2、fullnode-template.yaml <br>
3、genesis.blob <br>

通过 `docker-compose up` 快速启动 <br>