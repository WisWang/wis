# Task 0
I use windows to install vmware workstation, due to vmware edition is not pro, I use nginx to do the port forward, below is the nginx tcp forward config
```
stream {
    server {
        listen 22222;
        proxy_pass 192.168.66.128:22;
    }
    server {
        listen 28080;
        proxy_pass 192.168.66.128:80;
    }
    server {
        listen 28081 ;
        proxy_pass 192.168.66.128:8081 ;
    }
    server {
        listen 28082 ;
        proxy_pass 192.168.66.128:28082 ;
    }
    server {
        listen 31080 ;
        proxy_pass 192.168.66.128:31080 ;
    }
    server {
        listen 31081 ;
        proxy_pass 192.168.66.128:31081 ;
    }

}
```

# Task 1: Update system

login in the linux 
```
ssh wis@192.168.0.116 -p 22222
```
update system
```
root@wis:~# cd /etc/apt
root@wis:/etc/apt# cp sources.list sources.list.bak
root@wis:/etc/apt# vim sources.list
apt update
apt upgrade
```

# Task 2: install gitlab-ce version in the host

```
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
apt-get install gitlab-ce

gitlab-ctl reconfigure

cat /etc/gitlab/initial_root_password

```

# Task 3: create a demo group/project in gitlab


```
http://192.168.0.116:28080/demo/go-web-hello-world

```

# Task 4: build the app and expose ($ go run) the service to 28081 port


```
apt install golang

root@wis:~# cd /opt
root@wis:/opt# ls
root@wis:/opt# vim t3.go
root@wis:/opt# go run t3.go
```
t3.go

```
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Go Web Hello World!\n")
	})

	http.ListenAndServe(":8081", nil)
}
```

# Task 5: install docker

```
sudo apt-get install     ca-certificates     curl     gnupg     lsb-release
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl start docker.service
```

# Task 6: run the app in container

build a docker image ($ docker build) for the web app and run that in a container ($ docker run), expose the service to 28082 (-p)
https://docs.docker.com/engine/reference/commandline/build/
Check in the Dockerfile into gitlab
Expect output from host machine:
curl http://127.0.0.1:28082
Go Web Hello World!

```
cd /opt/docker/
cp ../t3.go ./
docker build -t app:1 .
docker run app:1 -p 28082:8081


curl http://192.168.0.116:28082
Go Web Hello World!
```

# Task 7: push image to dockerhub
tag the docker image using your_dockerhub_id/go-web-hello-world:v0.1 and push it to docker hub (https://hub.docker.com/)
Expect output: https://hub.docker.com/repository/docker/your_dockerhub_id/go-web-hello-world

```
docker login
docker tag app:1 wiswang/go-web-hello-world:v0.1
docker push wiswang/go-web-hello-world:v0.1
```

https://hub.docker.com/r/wiswang/go-web-hello-world

# Task 8: document the procedure in a MarkDown file
create a README.md file in the gitlab repo and add the technical procedure above (0-7) in this file


# Task 9: install a single node Kubernetes cluster using kubeadm
https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
Check in the admin.conf file into the gitlab repo

https://developer.aliyun.com/mirror/kubernetes?spm=a2c6h.13651102.0.0.3e221b114T7k7S


```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

systemctl enable kubelet && systemctl start kubelet

/etc/docker/daemon.json: 
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
sudo systemctl daemon-reload
sudo systemctl restart docker

kubeadm init \
     --image-repository registry.aliyuncs.com/google_containers \
     --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml


apt-get install bash-completion

source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc

echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

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


```

# Task 10: deploy the hello world container
in the kubernetes above and expose the service to nodePort 31080
Expect output:
curl http://127.0.0.1:31080
Go Web Hello World!
Check in the deployment yaml file or the command line into the gitlab repo

```
kubens default
vim application.yaml
k apply -f application.yaml

k taint node wis node-role.kubernetes.io/master:NoSchedule-

curl http://192.168.0.116:31080
Go Web Hello World!
```

# Task 11: install kubernetes dashboard
and expose the service to nodeport 31081
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
Expect output: https://127.0.0.1:31081 (asking for token)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

kubens kubernetes-dashboard


cat s.yaml
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 31081
  selector:
    k8s-app: kubernetes-dashboard

k delete svc kubernetes-dashboard
k apply -f s.yaml

```

# Task 12: generate token for dashboard login in task 11
figure out how to generate token to login to the dashboard and publish the procedure to the gitlab.

dashboard login url
https://192.168.0.116:31081/#/login

```
cat  dashboard-user.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard


k apply -f dashboard-user.yaml

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

```

# Task 13: publish your work
push all files/procedures in your local gitlab repo to remote github repo (e.g. https://github.com/your_github_id/go-web-hello-world)
if this is for an interview session, please send it to bo.cui@ericsson.com, no later than two calendar days after the interview.

https://github.com/WisWang/wis/tree/master/offline-project