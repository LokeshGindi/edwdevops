#!/bin/bash

tdhost="tdwd"
tduser="warehouse1"
tdpass=`grep -A6 "\[wh1_dsn\]" /home/etl_adhoc/.odbc.ini|grep Password|cut -d= -f2`
echo "
    .logon "${tdhost}"/"${tduser}","${tdpass}";
    .set width 10000
    .os rm -f /var/groupon/edwdevops/tdpass/tdpass.report
    .export report file=/var/groupon/edwdevops/tdpass/tdpass.report
    .set separator ','
    .run file /var/groupon/edwdevops/tdpass/tdpass.sql
    .export reset   
    .exit"> /var/groupon/edwdevops/tdpass/tdpass.bteq
bteq < /var/groupon/edwdevops/tdpass/tdpass.bteq
cat /var/groupon/edwdevops/tdpass/tdpass.report|tail -n +3|tr -d ' ' > /var/groupon/edwdevops/tdpass/tdpass.log

pass_exp=`awk -F, '{print " "$1"- "$2" days left,"}' /var/groupon/edwdevops/tdpass/tdpass.log|sed '$ s/.$//'`
if [ -z "${pass_exp}" ]; then pass_exp="None"; fi
echo "<p><b>TD batch password expiry</b> [next 15 days] :  ${pass_exp}</p>" > /var/groupon/edwdevops/tdpass/tdpass.html

