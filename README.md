# cli_bulk_launch

# Description
This set of scripts automates and tracks launching and terminating raw instances from a cloud CLI directly.

# WARNING
These scripts are experimental and have not been cleaned up to ensure safe usage.
Please read and understand the source before using.
Use at your own risk.

# Requirements
* aws_cli
** rs_services aws profile
```
[profile rs-services]
output=json
region = us-east-1
aws_access_key_id = #KEY#
aws_secret_access_key = #SECRET#        
```

# Scripts
## launch_rl10_instances.sh

* Usage:
Takes a parameter to indicate how many instances of each type to launch. Will create files in the current directory to track the resource-ids / ip-addresses of the launched instances.
```
./launch_rl10_instances.sh 10
```

## terminate_rl10_instances.sh
Expects the files from the launch script to exist in the current directory and will terminate each instance in the ids list file.
```
./terminate_rl10_instances.sh
```