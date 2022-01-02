# opsschool-mid-project-env
Environment for OpsSchool mid project

## Usage:
```
# create s3 bucket to hold the state of the configuration
cd terrafom/s3
tf init
tf apply --auto-aprove

# provision the project environment
cd ..
tf init
tf apply --auto-aprove

# install ansible dependencies
cd ../ansible
pip3 install docker
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.docker
#TODO: there's an issue with bastion not automatically added to known hosts
ssh-add ../terraform/opsschool_mid_project.pem
ansible-playbook mid-proj.playbook.yml

# ssh into jenkins server 
# configure the ssh agent key (and host?)
```
# points to put here
- vpc module sourced from github repo

# POINTS FOR IMPROVEMENT
- consider using ebs or custom ami instead of s3 for jenkins configuration backup
- jenkins roles have a lot in common - consider using a jenkins common role for these
- add more parameters in jenkins pipeline. e.g. for build
- fix ALB health checks for jenkins and consul
- use a safer method for deployment rather than having AWS env vars in the deployment yml and on jenkins

# useful commands
- create an SSH tunnel to a consul machine that holds the UI:</br>
`ssh -F ansible.ssh.config -N -f -L 8500:localhost:8500 ubuntu@<consul server private ip>` 
</br>then go to http://localhost:8500/ui

- once service account had iam role for Ec2FullAccess we can test it via:
`kubectl -n opsschool-mid-project-k8s-ns run --command=true --serviceaccount='k8s-sa' --rm -i --tty awscli --image=amazon/aws-cli --restart=Never aws ec2 describe-instances`

# known issues:
- when applying terraform in some cases there's an issue with dynamic tags. a consecutive apply usually does the trick. 