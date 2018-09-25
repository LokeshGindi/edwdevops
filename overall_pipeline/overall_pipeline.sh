#!/bin/bash
email_list=$1

while IFS='|' read -r subject jobname sla; do echo "select '${subject}' as subject, '${jobname}' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '${sla}' as sla, SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('${sla}')),':',2) as timediff, case when TIME_TO_SEC('${sla}') - TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -670 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when TIME_TO_SEC('${sla}') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like '${jobname}_$%' or name like '${jobname}_201%' or name='${jobname}') and cast(trigger_time as date)=current_date;"; done < /var/groupon/edwdevops/overall_pipeline/overall_pipeline.lst > /var/groupon/edwdevops/overall_pipeline/overall_pipeline.sql


mysql -hgds-snc1-prod-opswise-cntrl-rw-vip.snc1 -uopswise_ro -popswise_ro -Dopswise -N < /var/groupon/edwdevops/overall_pipeline/overall_pipeline.sql|tr '\t' ,|sed 's/'NULL'//g'|sort -t"," -k7d,7 -k6nr,6 > /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt

email_dt=`date "+%F %H:%M UTC"`
perc=$((100*$(cut -d, -f3 /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt|grep SUCCESS|wc -l)/$(cat /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt|wc -l)))
pipeline_dt=`date --date="yesterday" "+%F"`
pending_areas=`awk -F',' '$3!="SUCCESS" {print " "$1","}' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt|sed '$ s/.$//'|tr -d "\n"`
sla_missed=`awk -F',' '$7=="DELAYED" {print " "$1","}' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt|sed '$ s/.$//'|tr -d "\n"`

if [ -z "${pending_areas}" ]; then pending_areas="None"; fi
if [ -z "${sla_missed}" ]; then sla_missed="None"; fi
run_tm=`date '+%FT%TZ'`
utc_time=`date -u`

echo "From: edw-dev-ops@groupon.com
To: ${email_list}
Subject: [EDW] Overall Pipeline Status: ${email_dt}
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
<html><body>
<p><a href="http://pit-prod-owagent3.snc1:8080/overall_pipeline.html" target="_blank">Overall Pipeline Status >></a></p>" > /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html

echo "<html><title>Overall Pipeline Status</title><head><link rel="icon" href="favicon.png"></head><body>
<meta http-equiv="refresh" content="900">
<p style="display:inline">(Last refresh: </p>
<p style="display:inline" id="min_o"></p>
<p style="display:inline"> min back)
<br>EDW Pipeline Status for date ${pipeline_dt} - <b>${perc}% Completed</b></p>
<p><b>Pending Loads</b>- ${pending_areas}</p>
<p><b>SLAs missed</b>- ${sla_missed}</p>
<p>Last Refreshed UTC Time: <b>${utc_time}</b></p>
<script>
var refresh_o = new Date('${run_tm}');
var now_o = new Date();
var diff_o = now_o - refresh_o;
var diff_min_o = Math.round(diff_o / 60000);
document.getElementById('min_o').innerHTML= diff_min_o;
</script>" > /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html

echo "<table border=2 cellpadding=3 cellspacing=2>
<tr style="font-size:11px">
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>Subject</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>Job Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>Job Status</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>End Time</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>SLA</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>Delayed By</b></th>
  <th align=center style=white-space:nowrap bgcolor=#AED6F1><b>Delay Status</b></th>
</tr>"|tee -a /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html > /dev/null

cat /var/groupon/edwdevops/overall_pipeline/overall_pipeline.txt|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr style="font-size:11px"><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g'|tee -a /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html > /dev/null

echo "</table></body></html>"|tee -a /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html > /dev/null

sed -i -e 's/">DELAYED/color:#000000" bgcolor="#FE2E2E">DELAYED/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/">NEAR DELAYED/color:#000000" bgcolor="#FF69B4">NEAR DELAYED/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/">SUCCESS/color:#000000" bgcolor="#01DF01">SUCCESS/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/"> FAILED/color:#000000" bgcolor="#FE2E2E">FAILED/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/">ON-TIME/color:#000000" bgcolor="#01DF01">ON-TIME/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/">RUNNING/color:#000000" bgcolor="#CCD1D1">RUNNING/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html
sed -i -e 's/"> WAITING/color:#000000" bgcolor="#CCD1D1">WAITING/g' /var/groupon/edwdevops/overall_pipeline/overall_pipeline.html /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html

if [ -n "${email_list}" ]
then
cat /var/groupon/edwdevops/overall_pipeline/overall_pipeline_email.html|sendmail ${email_list}
fi
