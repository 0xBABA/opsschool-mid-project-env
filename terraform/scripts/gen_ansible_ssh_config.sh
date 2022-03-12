#!/bin/bash
eval "$(ssh-agent -s)"
ssh-add opsschool_mid_project.pem

cat << EOF > ../ansible/ansible.ssh.config
Host bastion
  Hostname ${1}
  User ubuntu
  IdentityFile ../terraform/opsschool_project.pem
  ForwardAgent yes
  ControlMaster auto
  ControlPath ~/.ssh/ansible-%r@%h:%p
  ControlPersist 5m


Host 10.0.12.*
  ProxyCommand ssh ubuntu@${1} -W %h:%p 
  IdentityFile ../terraform/opsschool_project.pem


Host 10.0.11.*
  ProxyCommand ssh ubuntu@${1} -W %h:%p 
  IdentityFile ../terraform/opsschool_project.pem
EOF