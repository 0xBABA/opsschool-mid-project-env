# Useful commands
- create an SSH tunnel to a consul machine that holds the UI:</br>
`ssh -F ansible.ssh.config -N -f -L 8500:localhost:8500 ubuntu@<consul server private ip>` 
</br>then go to http://localhost:8500/ui

- once service account has iam role for Ec2FullAccess we can test it via:
`kubectl -n opsschool-mid-project-k8s-ns run --command=true --serviceaccount='k8s-sa' --rm -i --tty awscli --image=amazon/aws-cli --restart=Never aws ec2 describe-instances`
