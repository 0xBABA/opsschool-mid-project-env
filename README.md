# opsschool-project-env
Environment for OpsSchool project


## Pre-requisites
1. Terrafrom and ansible installed on local machine or machine to which this repo was cloned.

2. This configuration provisions a managed RDS PostgreSQL DB. 
This DB is provisioned with admin user and later an ansible role configures an app user on the DB. 
For this, an AWS Secrets Manager (ASM) secret is expected to be in place. The required fields in the secret are as follows:
  ```
  'username': <your app user username>
  'password': <your app user password>
  'dbname': <your db name>
  'admin_user': <your db admin username>
  'admin_password': <your db admin password>
  ```
These will be used when provisioning and configuring the db for the first time, and will also be used by Kandula application.
The default secret name is defined in variables-db.tf, you can change this or provide your own secret name via --var flag to terraform apply command.

3. This configuration makes use of a public, simple, vpc module that provisions a vpc with 2 private and 2 public subnets. if you opt for using a different vpc module or provision on your own please update vpc.tf accordingly.

4. The apllication will run with a dedicated app user credentials. This IAM user is expected to be pre-provisioned before applying this configuration. Its credentials should be stored/updated in jenkins as secrets. See app-user-policy.json in the IAM directory for required permissions for this user. 

## Usage:
1. Create s3 bucket to hold the state of the configuration 
```
cd terrafom/s3
tf init
tf apply --auto-aprove
```
⚠️ Note that this will also provision an additional bucket used to store jenkins state

2. Provision the project environment

```
cd ..
tf init
tf apply --auto-aprove
```

3. install ansible dependencies
```
cd ../ansible
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.postgresql
```
4. Run the ansible playbook
```
ansible-playbook proj.playbook.yml
```


### Further configuration of Jenkins 
SSH to jenkins server instance
```
ssh -F ansible.ssh.config <jenkins server ip>
```
You can find jenkins initial admin password by running: 
```
cat jenkins_home/secrets/initialAdminPassword
```

Go to jenkins UI (ALB DNS name is output of TF configuration)
- Update the ssh pem file credential required for agents communincation (use generated pem file from terraform directory)


# Known issues:
- When applying terraform in some cases there's an issue with default tags. a consecutive apply usually resolves the issue. 

```
Error: Provider produced inconsistent final plan
When expanding the plan for <some resource> to include new values learned so far during apply, provider "registry.terraform.io/hashicorp/aws" produced an
invalid new value for .tags_all: new element "Name" has appeared. 
This is a bug in the provider, which should be reported in the provider's own issue tracker.
```
- Another option is to disable default_tags in providers.tf file. with this, though, you should keep in mind only "Name" tags will be set for some of the resources provisioned by this configuration. 

Thanks!
