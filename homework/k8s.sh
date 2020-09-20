#!/bin/bash
k label node kind-control-plane ingress-ready=true
k apply -f kubernetes/

echo "$(k describe node |grep InternalIP |awk '{print $NF}') www.dev.wis.com static.dev.wis.com" >> /etc/hosts
echo "$(k describe node |grep InternalIP |awk '{print $NF}') www.test.wis.com static.test.wis.com" >> /etc/hosts

