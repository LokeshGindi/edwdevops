#!/bin/bash
mysql -hgds-snc1-prod-opswise-cntrl-rw-vip.snc1 -uopswise_ro -popswise_ro -Dopswise </var/groupon/edwdevops/long_running/long_running.sql|tr '\t' ,|tail -n +2 >/var/groupon/edwdevops/long_running/long_running.csv

#############################
curl 'http://pit-prod-etljob1.snc1:50030/scheduler' > /var/groupon/edwdevops/long_running/long_running_petl.html
curl 'http://gdoop-resourcemanager-vip.snc1:8088/cluster/scheduler' > /var/groupon/edwdevops/long_running/long_running_gdoop.html
curl 'http://cerebro-resourcemanager-vip.snc1:8088/cluster/scheduler' > /var/groupon/edwdevops/long_running/long_running_cerebro.html

rm -f /var/groupon/edwdevops/long_running/long_running_hadoop.csv

grep -e '<td>\|<tr>\|selected>' /var/groupon/edwdevops/long_running/long_running_petl.html|grep -v "<tr><t" |tr -d '\n,'|sed 's/<tr>/\n/g'|sed 's/<td>//g'|sed '/^$/d'|sed 's/<\/td>/,/g'|sed 's/>/,/g'|sed 's/</,/g'|awk -F',' '$7=="etl_adhoc" || $7=="megatron" {print  "<a href=http://pit-prod-etljob1.snc1:50030/jobdetails.jsp?jobid=" $4 ">" $4 "</a>" FS $17 FS substr($8,1,30) FS system("echo -n `date --date=\""$1"\" +'%s'`;echo -n ,")}'|awk -F',' -v curr="$(date +'%s')" '{print $2 FS $4 FS "SNC1 Prod ETL" FS $3 FS int((curr-$1)/60)}' >> /var/groupon/edwdevops/long_running/long_running_hadoop.csv

grep '^\[' /var/groupon/edwdevops/long_running/long_running_gdoop.html |tr -d '\"\\'|awk -F"," -v curr="$(date +'%s')" '($2=="svc_edw_prod" || $2=="svc_meg_prod") {print $1 FS $5 FS $3 FS int((curr - substr($7,1,10))/60)}' | awk -F'[><]' '{print "<a href=http://gdoop-resourcemanager-vip.snc1:8088/cluster/app/" $3 ">" $3 "</a>," $0}'|awk -F"," '{print $1 FS substr($4,1,30) FS "Gdoop" FS $3 FS $5}' >> /var/groupon/edwdevops/long_running/long_running_hadoop.csv

grep '^\[' /var/groupon/edwdevops/long_running/long_running_cerebro.html |tr -d '\"\\'|awk -F"," -v curr="$(date +'%s')" '($2=="svc_edw_prod" || $2=="svc_replicator_prod") {print $1 FS $5 FS $3 FS int((curr - substr($7,1,10))/60)}' | awk -F'[><]' '{print "<a href=http://cerebro-resourcemanager-vip.snc1:8088/cluster/app/" $3 ">" $3 "</a>," $0}'|awk -F"," '{print $1 FS substr($4,1,30) FS "Cerebro" FS $3 FS $5}' >> /var/groupon/edwdevops/long_running/long_running_hadoop.csv

sort -t"," -k5nr,5 /var/groupon/edwdevops/long_running/long_running_hadoop.csv|awk -F"," '$5>30 {print $1 FS $2 FS $3 FS $4 FS int($5/60) ":" $5%60}' > /var/groupon/edwdevops/long_running/long_running_hadoop_merged.csv

#############################

ops_count=`wc -l < /var/groupon/edwdevops/long_running/long_running.csv`
hadoop_count=`wc -l < /var/groupon/edwdevops/long_running/long_running_hadoop_merged.csv`
run_tm=`date '+%FT%TZ'`

echo "<html><title>Long Running Jobs</title><head><link rel="icon" href="favicon.png"></head><body>
<meta http-equiv="refresh" content="900">
<p style="display:inline">(Last refresh: </p>
<p style="display:inline" id="min_l"></p>
<p style="display:inline"> min back)
<br>Long Running Opswise Job Count- <b>${ops_count}</b>
<br>Long Running Hadoop Job Count- <b>${hadoop_count}</b></p>
<script>
var refresh_l = new Date('${run_tm}');
var now_l = new Date();
var diff_l = now_l - refresh_l;
var diff_min_l = Math.round(diff_l / 60000);
document.getElementById('min_l').innerHTML= diff_min_l;
</script>

<h2>Long Running Opswise Jobs</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr style="font-size:10px">
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Job Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Job Type</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Trigger Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Run Duration</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Avg Dur</b></th>
</tr>" > /var/groupon/edwdevops/long_running/long_running.html

cat /var/groupon/edwdevops/long_running/long_running.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr style="font-size:10px" bgcolor="#@"><td align="left" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="left" style="white-space:nowrap;">/g' | awk -F"@" '{ if($0~">UNIX</td>") {print $1 "FFFFFF" $2} else {print $1 "DCD5D3" $2} }' >> /var/groupon/edwdevops/long_running/long_running.html

echo "</table>" >> /var/groupon/edwdevops/long_running/long_running.html

grep -v '^\[' /var/groupon/edwdevops/long_running/long_running_gdoop.html| tr -d '\n ,#'| sed -r 's/<tr>|<divclass/\n/g' > /var/groupon/edwdevops/long_running/g_queue_1.html
rm -f /var/groupon/edwdevops/long_running/g_queue_2.html
for i in `cat /var/groupon/edwdevops/long_running/g_queue_1.html`; do echo $i|grep -Eo 'Queue:[^<]*' >> /var/groupon/edwdevops/long_running/g_queue_2.html; echo $i| grep -e svc_edw_prod -e svc_janus -e svc_meg_prod -e svc_replicator_prod >> /var/groupon/edwdevops/long_running/g_queue_2.html; done
sed 's#</td><td>#,#g' /var/groupon/edwdevops/long_running/g_queue_2.html|sed 's/vCores:/,/g'| sed -r 's#<td>|&lt;|&gt;|</td>|</tr>##g'|cut -d, -f1,3,5,10,11|tr '\n' '#'|sed 's/Queue:/\nQueue:/g'|tail -n +2|awk -F'#' '{if ( NF != 2 ) print $0}'|sed 's/.$//'|tr '#' '\n'|awk -F',' '{if ( NF == 5 ) print $1 FS $2 FS int(($3*100)/$2) "%" FS $4 FS $5; else print $0}' > /var/groupon/edwdevops/long_running/g_queue.csv


echo "<h2>Gdoop Queue Status</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr style="font-size:10px">
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>User Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Total Resource</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Used %</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Running Apps</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Waiting Apps</b></th>
</tr>" >> /var/groupon/edwdevops/long_running/long_running.html

cat /var/groupon/edwdevops/long_running/g_queue.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr style="font-size:10px" bgcolor="#@"><td align="left" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="left" style="white-space:nowrap;">/g' | awk -F"@" '{ if($0~">UNIX</td>") {print $1 "FFFFFF" $2} else {print $1 "DCD5D3" $2} }' >> /var/groupon/edwdevops/long_running/long_running.html

echo "</table>" >> /var/groupon/edwdevops/long_running/long_running.html
sed -i -e 's/">Queue:/font-size:15px;color:#000000" bgcolor="#FFFFFF">Queue:/g' /var/groupon/edwdevops/long_running/long_running.html


echo "<h2>Long Running Hadoop Jobs (Run Duration > 30 min)</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr style="font-size:10px">
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Job ID</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Job Name Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Host</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Queue</b></th>
  <th align=center style=white-space:nowrap bgcolor=#81BEF7><b>Run Duration</b></th>
</tr>" >> /var/groupon/edwdevops/long_running/long_running.html

cat /var/groupon/edwdevops/long_running/long_running_hadoop_merged.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr style="font-size:10px"><td align="left" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="left" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/long_running/long_running.html
echo "</table></body></html>" >> /var/groupon/edwdevops/long_running/long_running.html

cp /var/groupon/edwdevops/long_running/long_running.html  /var/groupon/edwdevops/edw-dev-ops/archive/long_running/long_running_$(date +%F_%T).html
