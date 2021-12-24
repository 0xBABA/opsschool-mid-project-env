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
ansible-galaxy collection install amazon.aws

# ansible ssh configuration
eval "$(ssh-agent -s)"
ssh-add ../terraform/opsschool_mid_project.pem
remove the .exmaple postfix from the file and add your bastion ip

```
# points to put here
- vpc module sourced from github repo

# POINTS FOR IMPROVEMENT
- automate the ansinble.ssh.config creation (i.e. get the bastion ip and generate a file)