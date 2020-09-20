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

# 