#!/bin/bash

LIST=$(/usr/sbin/xm list | grep vm | cut -d' ' -f 1 | cut -d'm' -f 2)
for i in $LIST ; do
  echo "puppetd --test" | ssh root@10.10.10.${i} -p22 'bash -s'
done

