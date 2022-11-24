#!/bin/bash

/usr/bin/df -l -P | /usr/bin/awk '{if (NR!=1) print $6}' | /usr/bin/xargs -I '{}' find '{}' -xdev -type f -perm -0002