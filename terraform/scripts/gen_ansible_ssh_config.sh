#!/bin/bash
eval "$(ssh-agent -s)"
ssh-add opsschool_mid_project.pem

cat << EOF > ../ansible/ansible.ssh.config
Host bastion
  Hostname ${1}
  User ubuntu
  IdentityFile ../terraform/opsschool_project.pem

Host 10.0.*.*
  User ubuntu
  IdentityFile ../terraform/opsschool_project.pem
  ProxyJump bastion
  StrictHostKeyChecking no
EOF