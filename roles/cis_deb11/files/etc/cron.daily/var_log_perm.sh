#!/usr/bin/env bash
#
# VPP Debian Linux Hardening v2.0 (17.10.2022)
#
# Script runs daily and is fixing permissions in /var/log
{
 find /var/log -type f | while read -r fname; do
 bname="$(basename "$fname")"
 case "$bname" in
 lastlog | lastlog.* | wtmp | wtmp.* | btmp | btmp.*)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6][0,4]\h*$' && chmod ug-x,o-wx "$fname"
 ! stat -Lc "%U" "$fname" | grep -Pq -- '^\h*root\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Pq -- '^\h*(utmp|root)\h*$' && chgrp root "$fname" 
 ;; 
 secure | auth.log)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' && chmod u-x,g-wx,o-rwx "$fname"
 ! stat -Lc "%U" "$fname" | grep -Pq -- '^\h*(syslog|root)\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Pq -- '^\h*(adm|root)\h*$' && chgrp root "$fname"
 ;;
 SSSD | sssd)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$' && chmod ug-x,o-rwx "$fname"
 ! stat -Lc "%U" "$fname" | grep -Piq -- '^\h*(SSSD|root)\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Piq -- '^\h*(SSSD|root)\h*$' && chgrp root "$fname"
 ;;
 gdm | gdm3)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$' && chmod ug-x,o-rwx
 ! stat -Lc "%U" "$fname" | grep -Pq -- '^\h*root\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Pq -- '^\h*(gdm3?|root)\h*$' && chgrp root "$fname"
 ;;
 *.journal)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' && chmod u-x,g-wx,o-rwx "$fname"
 ! stat -Lc "%U" "$fname" | grep -Pq -- '^\h*root\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Pq -- '^\h*(systemdjournal|root)\h*$' && chgrp root "$fname"
 ;;
 *)
 ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' && chmod u-x,g-wx,o-rwx "$fname"
 ! stat -Lc "%U" "$fname" | grep -Pq -- '^\h*(syslog|root)\h*$' && chown root "$fname"
 ! stat -Lc "%G" "$fname" | grep -Pq -- '^\h*(adm|root)\h*$' && chgrp root "$fname"
 ;;
 esac
 done
}
