### Installing and Configuring AWS CLI
---

Installing using `pip3`
```
pip3 install --user awscli
```
Verify that the AWS CLI is installed correctly.
```
aws --version
```

Configure
```
aws configure
AWS Access Key ID [None]: ALC5R7MFJ
AWS Secret Access Key [None]: qYs1VJ+rt5xmktSLZ
Default region name [None]: us-west-1
Default output format [None]: json
```

Review the files
~/.aws/credentials
~/.aws/config


aws ec2 describe-instances --filter Name=vpc-id,Values=vpc-05be1950654e222db
Get Instance Name
aws ec2 describe-instances --filter Name=vpc-id,Values=vpc-05be1950654e222db --query 'Reservations[].Instances[].{Name: Tags[?Key==].Value | [0]}' --output text


To describe instances with a specific tag and filter the results to specific fields

aws ec2 describe-instances \
    --filter Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table


Get Output of running machines to store the output /etc/hosts file
```
aws ec2 describe-instances \
    --filter Name=tag-key,Values=Name --filter Name=instance-state-name,Values=running\
    --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value,Instance:PublicIpAddress}' --output text
```
