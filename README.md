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
```
# points to put here
- vpc module sourced from github repo
