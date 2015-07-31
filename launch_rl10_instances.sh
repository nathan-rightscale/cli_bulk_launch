#!/bin/bash -x

if [ -f instances.json -o -f instance_ids.list ]; then
    echo "instance.json or instance_ids.list already exist"
    exit 1
else
    touch instances.json
    touch instance-ids.list
fi

#Ubuntu 14.04
aws --profile rs-services ec2 run-instances --image-id ami-5f6a8034 --key ndb-rs-service-test --instance-type t1.micro --count $1 >> instances.json

#Ubuntu 12.04
aws --profile rs-services ec2 run-instances --image-id ami-c52bdfae --key ndb-rs-service-test --instance-type t1.micro --count $1 >> instances.json

#CentOS 7
#aws --profile rs-services ec2 run-instances --image-id ami-96a818fe --key ndb-rs-service-test --instance-type t2.micro --subnet-id subnet-6804fc1ep --count 1 >> instances.json

#RHEL 7
#aws --profile rs-services ec2 run-instances --image-id ami-12663b7a --key ndb-rs-service-test --instance-type t2.micro --subnet-id subnet-6804fc1ep --count 1 >> instances.json

#RHEL 6
#aws --profile rs-services ec2 run-instances --image-id ami-b18c62da --key ndb-rs-service-test --instance-type t2.micro --subnet-id subnet-6804fc1ep --count 1 >> instances.json

#Aggregate the instance id's to a file
grep InstanceId instances.json | awk '{print $2}' | sed 's/[",]//g' >> instance-ids.list

#List instances until all instances have ip addresses
all_ips=0
while [ $all_ips == 0 ]; do
    :> instances_status.json
    for i in `cat instance-ids.list`; do
	aws --profile rs-services ec2 describe-instances --instance-id $i >> instances_status.json
    done
    public_ip_count=`grep "PublicIpAddress" instances_status.json | awk '{print $2}' | sed 's/[",]//g' | wc -l`
    if [ $public_ip_count == `wc -l instance-ids.list | awk '{print $1}'` ]; then
	#Then all servers have IP's
	grep "PublicIpAddress" instances_status.json | awk '{print $2}' | sed 's/[",]//g' >> instance_ips.list
	all_ips=1
    else
	sleep 10
    fi
done
