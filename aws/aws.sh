#!/bin/bash

aws ec2 describe-instances \
    --filter Name=tag-key,Values=Name Name=instance-state-name,Values=running\
    --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value,Instance:PublicIpAddress}' --output text
