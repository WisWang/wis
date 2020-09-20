# Background

The environment is :

```shell
[root@node1 kubernetes]# rpm -qf /etc/issue
centos-release-7-6.1810.2.el7.centos.x86_64
```

All the command below is only on this system.

# DEV/QA env build

## Init os

Below command should use root.

```shell
git clone https://github.com/WisWang/wis.git
cd wis/homework
./init.sh
./k8s.sh
```

Then use `https://github.com/WisWang/wis/homework/Jenkinsfile` on Jenkins to build pipeline.

# 生产环境

## 高可用

生产环境的高可用

- 私有云，主要考虑网络设备的高可用（核心，汇聚，接入的交换机和路由器等等），多机房部署的话，专线的高可用也需要考虑。
- 公有云，选择多区域，多可用区部署就可以了，大部分产品都支持的。并且做好备份。

应用的高可用 k8s 是

## 监控和告警

监控的话，主要大致可以分为基础设施，应用，全链路，业务4个方面

- 基础设施用promethus
- 应用监控如延时，流量，异常可以通过收集接入ingress的日志到ELK来查看，应用的负载情况可以参考基础设置的监控
- 全链路监控可以使用skywalking
- 业务监控就要根据具体的业务形态来定了

## 日志

日志可以参考下面这个架构：
![日志架构](https://img2018.cnblogs.com/blog/635909/201810/635909-20181030215156631-2078677630.jpg "log")
非常重要的一个点就是要通过消息队列(kafka)来解耦日志收集和日志分析。
