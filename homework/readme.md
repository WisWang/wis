# Background

The environment is :

```shell
[root@node1 kubernetes]# rpm -qf /etc/issue
centos-release-7-6.1810.2.el7.centos.x86_64
```

All the command below is only on this server. Jenkins is also on the server.

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

# Production

## HA

HA in production environment:

- Private cloud mainly considers the high availability of network equipment (core, aggregation, access switches and routers, etc.). If multiple DC are deployed, the high availability of physical connection also needs to be considered.
- Public cloud, you can choose multi region and multi avaliable zone deployment, which is supported by most products. And make a backup.

Kubernetes taken over the HA of applications.

## Monitoring

Monitoring can be roughly divided into four aspects: infrastructure , application, tracing, and business.

- Infrastructure (Prometheus)
- Application monitoring such as delay, traffic, and errors can be viewed by collecting ingress logs to ELK, and the load of the application can refer to Prometheus
- Tracing (skywalking)
- Business monitoring should be determined according to the specific business field

## Log

Log can refer to the following architecture:
![Log architecture](https://img2018.cnblogs.com/blog/635909/201810/635909-20181030215156631-2078677630.jpg "log")
Log architecture A very important point is to decouple log collection and log analysis through the message queue (kafka).
