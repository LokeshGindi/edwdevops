#!/bin/bash
if [ -n "$1" ]; then email_list=$1; else email_list="edw-dev-ops@groupon.com"; fi

##################  FS Space  ###############

rm -f /var/groupon/edwdevops/space_usage/space_usage.log
rm -f /var/groupon/edwdevops/space_usage/space_usage.txt

IFS=$'\n'; for line in `cat /var/groupon/edwdevops/space_usage/space_usage.lst|grep ^fs|cut -d, -f2,3`; do h=`echo $line|cut -d, -f1`; k=`echo $line|cut -d, -f2`; cat /var/groupon/edwdevops/space_usage/space_usage.template|sed 's#key#'$k'#g'|sed 's#hostname#'$h'#g' >> /var/groupon/edwdevops/space_usage/space_usage.txt; done;

sh /var/groupon/edwdevops/space_usage/space_usage.txt

##################  TDWC Space  ###############

tdhost="tdwd"
tduser="warehouse1"
tdpass=`grep -A6 "\[wh1_dsn\]" /home/etl_adhoc/.odbc.ini|grep Password|cut -d= -f2`
echo "
    .logon "${tdhost}"/"${tduser}","${tdpass}";
    .set width 10000
    .os rm -f /var/groupon/edwdevops/space_usage/space_usage.report
    .export report file=/var/groupon/edwdevops/space_usage/space_usage.report
    .set separator ','
    .run file /var/groupon/edwdevops/space_usage/space_usage.sql
    .export reset   
    .exit"> /var/groupon/edwdevops/space_usage/space_usage.bteq
bteq < /var/groupon/edwdevops/space_usage/space_usage.bteq
cat /var/groupon/edwdevops/space_usage/space_usage.report|tail -n +3|tr -d ' ' > /var/groupon/edwdevops/space_usage/space_usage2.log
################ TDDR SPACE ###################

td_host="tddr"
td_user="warehouse1"
td_pass=$(ssh gdoop-job-submitter2-sox.sac1 'grep -A6  "\[dw_dsn\]"   /home/svc_sox/.odbc.ini|grep Password|cut -d= -f2')

echo "
    .logon "${td_host}"/"${td_user}","${td_pass}";
    .set width 10000
    .os rm -f /var/groupon/tmp/space_usage_sac.report
    .export report file=/var/groupon/tmp/space_usage_sac.report
    .set separator ','
    .run file /var/groupon/tmp/space_usage_sac.sql
    .export reset
    .exit"> /var/groupon/edwdevops/space_usage/space_usage_sac.bteq
#bteq < /var/groupon/edwdevops/space_usage/space_usage_sac.bteq

scp  /var/groupon/edwdevops/space_usage/space_usage_sac.bteq gdoop-job-submitter2-sox.sac1:/var/groupon/tmp/
scp  /var/groupon/edwdevops/space_usage/space_usage_sac.sql gdoop-job-submitter2-sox.sac1:/var/groupon/tmp/
ssh gdoop-job-submitter2-sox.sac1 'bteq </var/groupon/tmp/space_usage_sac.bteq >/var/groupon/tmp/space_usage_sac.report'
scp gdoop-job-submitter2-sox.sac1:/var/groupon/tmp/space_usage_sac.report /var/groupon/edwdevops/space_usage/space_usage_sac.report
cat  /var/groupon/edwdevops/space_usage/space_usage_sac.report|tail -n +3|tr -d ' ' > /var/groupon/edwdevops/space_usage/space_usage2_sac.log

##################  DFS Space  ###############

hadoop dfsadmin -report |head|grep -Eo 'DFS Used%:[^.]*'|cut -c12-|awk '{if ($0>90) print "PETL",$0,"FAILED"; else print "PETL,"$0",SUCCESS"}' > /var/groupon/edwdevops/space_usage/space_usage3.log

ssh cerebro-job-submitter1.snc1 'hadoop dfsadmin -report 2>/dev/null'|head|grep -Eo 'DFS Used%:[^.]*'|cut -c12-|awk '{if ($0>90) print "Cerebro,"$0",FAILED"; else print "Cerebro,"$0",SUCCESS"}' >> /var/groupon/edwdevops/space_usage/space_usage3.log

ssh gdoop-owagent2.snc1 'hadoop dfsadmin -report 2>/dev/null'|head|grep -Eo 'DFS Used%:[^.]*'|cut -c12-|awk '{if ($0>90) print "Gdoop,"$0",FAILED"; else print "Gdoop,"$0",SUCCESS"}' >> /var/groupon/edwdevops/space_usage/space_usage3.log

ssh -i /home/etl_adhoc/.ssh/gdoop_sox_snc1 svc_sox@gdoop-job-submitter1-sox.snc1 'hadoop dfsadmin -report 2>/dev/null'|head|grep -Eo 'DFS Used%:[^.]*'|cut -c12-|awk '{if ($0>90) print "Gdoop-Sox,"$0",FAILED"; else print "Gdoop-Sox,"$0",SUCCESS"}' >> /var/groupon/edwdevops/space_usage/space_usage3.log

##################  Hadoop Quota  ###############

rm -f /var/groupon/edwdevops/space_usage/space_usage4.log
rm -f /var/groupon/edwdevops/space_usage/space_usage4.txt

IFS=$'\n'; for line in `cat /var/groupon/edwdevops/space_usage/space_usage.lst|grep ^quota|cut -d, -f2,3`; do u=`echo $line|cut -d, -f1`; s=`echo $line|cut -d, -f2`; cat /var/groupon/edwdevops/space_usage/space_usage.template2|sed  's#ssh1#'$s'#g'|sed 's#username#'$u'#g' >> /var/groupon/edwdevops/space_usage/space_usage4.txt; done;

sh /var/groupon/edwdevops/space_usage/space_usage4.txt

#############################################

echo "From:edw-dev-ops@groupon.com
To:${email_list}
Subject: FAILED- Global Space Usage Report
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
<html><body>
<p>Please check- <a href="http://pit-prod-owagent3.snc1:8080/space_usage.html" target="_blank">Space usage >></a></p>
</body></html>" > /var/groupon/edwdevops/space_usage/space_usage_email.html

run_tm=`date '+%FT%TZ'`
hadoop_space=`awk -F, '{print " "$1"- "$2"%,"}' /var/groupon/edwdevops/space_usage/space_usage3.log|sed '$ s/.$//'|tr -d "\n"`

echo "<html><title>Space Usage Report</title><head><link rel="icon" href="favicon.png"></head><body>
<meta http-equiv="refresh" content="900">
<p style="display:inline">(Last refresh: </p>
<p style="display:inline" id="min_s"></p>
<p style="display:inline"> min back)
<br><b>Hadoop Cluster Usage-</b>${hadoop_space}</p>
<script>
var refresh_s = new Date('${run_tm}');
var now_s = new Date();
var diff_s = now_s - refresh_s;
var diff_min_s = Math.round(diff_s / 60000);
document.getElementById('min_s').innerHTML= diff_min_s;
</script>" > /var/groupon/edwdevops/space_usage/space_usage.html

tdwc_fcount=`grep FAILED /var/groupon/edwdevops/space_usage/space_usage2.log|wc -l`
echo "<h3>TDWD Space usage</h3>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Database Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Max Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Remaining Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Perc</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Status (>90%)</b></th>
</tr>" >> /var/groupon/edwdevops/space_usage/space_usage.html
cat /var/groupon/edwdevops/space_usage/space_usage2.log|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/space_usage/space_usage.html
echo "</table>" >> /var/groupon/edwdevops/space_usage/space_usage.html


tdwc_fcount_sac=`grep FAILED /var/groupon/edwdevops/space_usage/space_usage2_sac.log|wc -l`
echo "<h3>TDDR Space usage</h3>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Database Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Max Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Remaining Space (GB)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Perc</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Status (>90%)</b></th>
</tr>" >> /var/groupon/edwdevops/space_usage/space_usage.html
cat /var/groupon/edwdevops/space_usage/space_usage2_sac.log|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/space_usage/space_usage.html
echo "</table>" >> /var/groupon/edwdevops/space_usage/space_usage.html



dfs_fcount=`grep FAILED /var/groupon/edwdevops/space_usage/space_usage3.log|wc -l`
echo "<h3>HDFS Space usage</h3>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Host</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Perc</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Status (>90%)</b></th>
</tr>" >> /var/groupon/edwdevops/space_usage/space_usage.html
cat /var/groupon/edwdevops/space_usage/space_usage3.log|sort  --field-separator=',' -k2 -nr|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/space_usage/space_usage.html
echo "</table>" >> /var/groupon/edwdevops/space_usage/space_usage.html



fs_fcount=`grep FAILED /var/groupon/edwdevops/space_usage/space_usage.log|wc -l`
echo "<h3>FS Space usage</h3>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Agent Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Filesystem</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Size</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Avail</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used Perc</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Mounted On</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Status (>90%)</b></th>
</tr>" >> /var/groupon/edwdevops/space_usage/space_usage.html
cat /var/groupon/edwdevops/space_usage/space_usage.log|sort  --field-separator=',' -k6 -nr|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/space_usage/space_usage.html
echo "</table>" >> /var/groupon/edwdevops/space_usage/space_usage.html


q_fcount=`grep FAILED /var/groupon/edwdevops/space_usage/space_usage4.log|wc -l`
echo "<h3>Hadoop quota usage</h3>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Username</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Quota</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Remaining</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Usage</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Status (>95%)</b></th>
</tr>" >> /var/groupon/edwdevops/space_usage/space_usage.html
cat /var/groupon/edwdevops/space_usage/space_usage4.log|sort  --field-separator=',' -k4 -nr|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/space_usage/space_usage.html
echo "</table></body></html>" >> /var/groupon/edwdevops/space_usage/space_usage.html



sed -i -e 's/">FAILED/color:#000000" bgcolor="#FE2E2E">FAILED/g' /var/groupon/edwdevops/space_usage/space_usage.html

if [ `expr $tdwc_fcount + $tdwc_fcount_sac + $fs_fcount + $dfs_fcount + $q_fcount`  -gt 0 ]
then
cat /var/groupon/edwdevops/space_usage/space_usage_email.html|sendmail ${email_list}
fi
