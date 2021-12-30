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

```
# points to put here
- vpc module sourced from github repo

# POINTS FOR IMPROVEMENT
- consider using ebs instead of s3 for jenkins configuration backup
- mention UIs access via ALB if i dont get there. mention in instarcution how to create ssh tunnel for consul and jenkins servers
- jenkins roles have a lot in common - consider using a jenkins common role for these

# useful commands
- create an SSH tunnel to a consul machine that holds the UI:</br>
`ssh -F ansible.ssh.config -N -f -L 8500:localhost:8500 ubuntu@<consul server private ip>` 
</br>then go to http://localhost:8500/ui