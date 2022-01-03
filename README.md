# opsschool-mid-project-env
Environment for OpsSchool mid project

## Usage:
### Provision and configure
1. Create s3 bucket to hold the state of the configuration 
```
cd terrafom/s3
tf init
tf apply --auto-aprove
```
⚠️ Note that this will also provision an additional bucket used to store jenkins state

2. Provision the project environment and capture outputs like jenkins and consul UI dns

```
cd ..
tf init
tf apply --auto-aprove
```

3. install ansible dependencies
```
cd ../ansible
pip3 install docker
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.docker
ssh-add ../terraform/opsschool_mid_project.pem
```
4. Run the ansible playbook
```
ansible-playbook mid-proj.playbook.yml
```

### Further configuration of Jenkins 
SSH to jenkins server instance
```
ssh -F ansible.ssh.config ubuntu@<jenkins server ip>
```
You can find jenkins initial admin password by running: 
```
cat jenkins_home/secrets/initialAdminPassword
```

Go to jenkins UI (ALB DNS name is output of TF configuration)
- Update agents ip
- Update the ssh pem file credential required for agents communincation (use generated pem file in terraform directory)


# Known issues:
- When applying terraform in some cases there's an issue with dynamic tags. a consecutive apply usually does the trick. 
</br>
```
Error: Provider produced inconsistent final plan
 
 When expanding the plan for <some resource> to include new values learned so far during apply, provider "registry.terraform.io/hashicorp/aws" produced an
 invalid new value for .tags_all: new element "Name" has appeared.
 
 This is a bug in the provider, which should be reported in the provider's own issue tracker.
```