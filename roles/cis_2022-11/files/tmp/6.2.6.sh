#!/bin/bash
#
# VPP Linux Hardening
#
# check if duplicated GIDs exist


cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
 echo "Duplicate GID ($x) in /etc/group"
done