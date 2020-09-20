#!/bin/bash

# install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce
service docker start

# install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/bin/
kind create cluster

# install kubectl
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl

# install kubens 
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << FOE >> ~/.bashrc
alias k='kubectl'
#kubectx and kubens
export PATH=~/.kubectx:\$PATH
FOE

# 

k label node kind-control-plane ingress-ready=true


echo "$(k describe node |grep InternalIP |awk '{print $NF}') www.wis.com static.wis.com" >> /etc/hosts

# jenkins setup

yum install java-1.8.0-openjdk
yum install -y https://mirrors.aliyun.com/jenkins/redhat/jenkins-2.257-1.1.noarch.rpm
systemctl start jenkins
echo "jenkins ALL = (root) NOPASSWD: ALL" >> /etc/sudoers
