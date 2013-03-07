#!/bin/sh

# Color define
defcolor="\033[0m"
pur="\033[35m"

# Check argument
MESSAGES=${1}
NUMERIC_CHECK=`echo ${MESSAGES} | sed 's/[0-9]//g'`

# Print usage
if [ $# -ne 1 ] || [[ -z ${MESSAGES} ]] || [[ -n ${NUMERIC_CHECK} ]] || [ ${MESSAGES} -le 0 ]; then
    echo "Usage : sh $0 100"
    exit 1;
fi

# Send bucket message
for i in `seq 1 $1`
do
    python create_app_bucket_object.py
    echo "${pur} =====> PushToApp / $i times done : `date +%s`${defcolor}"
    sleep 2
done

# Send topic message
for i in `seq 1 $1`
do
    python sendmessage.py
    echo "${pur} =====> PushToUser / $i times done : `date +%s`${defcolor}"
    sleep 2
done


