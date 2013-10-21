#!/bin/bash

LIST=$(/usr/sbin/xm list | grep -v Name | grep -v Domain | grep vm | cut -d' ' -f 1)
for VM in $LIST; do
  echo "Begin backup $VM ($(date))"
  mkdir -p /srv/backups/$VM
  rsync -avz $VM:/home/minecraft/world_backups /srv/backups/$VM
  echo "End backup $VMi ($(date))"
done

