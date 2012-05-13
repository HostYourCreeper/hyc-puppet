#!/bin/bash

usage()
{
    echo "Usage: $0 -n vm_number -m memory_size -s shared_memory_size -o ssh -b backup -d disk_space_added"
    exit
}

while getopts n:m:s:o:b:d: option
do
 case $option in
  n)
   NUMBER=$OPTARG 
   ;;
  m)
   MEMORY=$OPTARG
   ;;
  s)
   SHARED=$OPTARG
   ;;
  o)
   SSH=$OPTARG
   ;;
  b)
    BACKUP=$OPTARG
   ;;
  d)
    DISK=$OPTARG
   ;;
  *) usage
   ;; 
  esac
done

if [[ -z $MEMORY ]]
then
    MEMORY=1024
fi

if [[ -z $SHARED ]]
then
    SHARED=256
fi

if [[ -z $SSH ]]
then
    SSH=0
fi
if [[ -z $BACKUP ]]
then
    BACKUP=0
fi
if [[ -z $DISK ]]
then
    DISK=0
fi
DISK=$((${DISK}+6))Gb


PASSWORD=$(pwgen -s 12 1)
DB_PASSWORD=$(pwgen -s 12 1)
MURMUR_PASSWORD=$(pwgen -s 12 1)
HOST="vm${NUMBER}"
# Reglage de la gateway
DOMU_IP="10.10.10.${NUMBER}"
GATEWAY=$(echo $DOMU_IP | awk -F. '{print $1"."$2"."$3"."$4 + 127}')

VM_MEMORY=$((${MEMORY}+128))M

RETOUR=$(xen-create-image \
--hostname=$HOST \
--ip=$DOMU_IP \
--arch=amd64 \
--dist=squeeze \
--gateway=$GATEWAY \
--role=minecraft \
--role-args="$(mkpasswd ${PASSWORD}) $MEMORY $SHARED $DOMU_IP $BACKUP $DB_PASSWORD $MURMUR_PASSWORD $SSH" \
--size=$DISK \
--memory=$VM_MEMORY)


ROOT_PASS=$(echo $RETOUR | egrep -o 'Root Password.*' | awk '{print $4}')
echo "${ROOT_PASS}"

# Reglage du maxmem
FILE=/etc/xen/${HOST}.cfg; 
#GREP=$(grep maxmem $FILE); 
#if [[ $SHARED == 768 ]]
#then
#  AWK=$(echo $GREP | awk -F\' '{print $1"'\''"$2+768"'\''"}');
#elif [[ $SHARED == 1280 ]]
#then
#  AWK=$(echo $GREP | awk -F\' '{print $1"'\''"$2+1280"'\''"}');
#else
#  AWK=$(echo $GREP | awk -F\' '{print $1"'\''"$2+256"'\''"}');
#fi
#sed -e "s/${GREP}/${AWK}/g" -i $FILE

RETOUR2=$(xm create ${FILE})

echo "${PASSWORD}"
echo "${DB_PASSWORD}"
echo "${MURMUR_PASSWORD}"

touch /opt/firewall/vm/${NUMBER}

/opt/firewall/firewall.sh restart
