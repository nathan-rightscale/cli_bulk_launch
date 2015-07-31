#!/bin/bash -x

if [ ! -f 'instance-ids.list' ]; then
    echo "Missing instance-ids.list"
    exit 1
fi

for i in `cat instance-ids.list`; do
    aws --profile rs-services ec2 terminate-instances --instance-id $i
done

all_term=0
while [ $all_term == 0 ]; do
    :> instances_status.json
    for i in `cat instance-ids.list`; do
	aws --profile rs-services ec2 describe-instances --instance-id $i >> instances_status.json 
    done
    term_count=`grep "terminated" instances_status.json -c`
    
    if [ $term_count == `wc -l instance-ids.list | awk '{print $1}'` ]; then
	all_term=1
	rm *.json
	rm *.list
    else
	sleep 10
    fi
done
