#!/bin/bash
k label node kind-control-plane ingress-ready=true
k apply -f kubernetes/

echo "$(k describe node |grep InternalIP |awk '{print $NF}') www.wis.com static.wis.com" >> /etc/hosts

