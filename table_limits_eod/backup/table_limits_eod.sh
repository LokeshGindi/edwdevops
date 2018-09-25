#!/bin/bash

echo "select case when consistent_before_hard < current_date then 'FAILED' else 'SUCCESS' end as status, consistent_before_hard, CONCAT(schema_name,'/',table_name,'/',content_group) as tablename from dwh_manage.table_limits where (1=0)" > /var/groupon/edwdevops/table_limits_eod/na_core_mysql.sql
awk -F'/' '{print "OR (schema_name=" $1 " and table_name=" $2 " and content_group=" $3 ")"}' /var/groupon/edwdevops/table_limits_eod/na_core.lst >> /var/groupon/edwdevops/table_limits_eod/na_core_mysql.sql
echo ";" >> /var/groupon/edwdevops/table_limits_eod/na_core_mysql.sql


mysql -hprod-pitstop-rw-vip.us.daas.grpn -udwhuser -pdwhpass dwh_manage </var/groupon/edwdevops/table_limits_eod/intl_dash_mysql.sql|tr '\t' ,|tail -n +2 > /var/groupon/edwdevops/table_limits_eod/intl_dash_mysql.csv
mysql -hprod-pitstop-rw-vip.us.daas.grpn -udwhuser -pdwhpass dwh_manage </var/groupon/edwdevops/table_limits_eod/na_core_mysql.sql|tr '\t' ,|tail -n +2 > /var/groupon/edwdevops/table_limits_eod/na_core_mysql.csv
mysql -hprod-pitstop-rw-vip.us.daas.grpn -udwhuser -pdwhpass dwh_manage </var/groupon/edwdevops/table_limits_eod/deal_unity_map_mysql.sql|tr '\t' ,|tail -n +2 > /var/groupon/edwdevops/table_limits_eod/deal_unity_map_mysql.csv

tdhost="tdwc"
tduser="warehouse1"
tdpass=`grep -A6 "\[wh1_dsn\]" /home/etl_adhoc/.odbc.ini|grep Password|cut -d= -f2`

echo "
    .logon "${tdhost}"/"${tduser}","${tdpass}";
    .set width 10000
    .os rm -f /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.report
    .export report file=/var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.report
    .set separator ','
    .run file /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.sql
    .export reset
    .exit"> /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.bteq
bteq < /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.bteq
cat /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.report|tail -n +3|tr -s ' ' > /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.csv

echo "
    .logon "${tdhost}"/"${tduser}","${tdpass}";
    .set width 10000
    .os rm -f /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.report
    .export report file=/var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.report
    .set separator ','
    .run file /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.sql
    .export reset
    .exit"> /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.bteq
bteq < /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.bteq
cat /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.report|tail -n +3|tr -s ' ' > /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.csv


cat /var/groupon/edwdevops/table_limits_eod/intl_dash_mysql.csv /var/groupon/edwdevops/table_limits_eod/intl_dash_tdwc.csv|sort > /var/groupon/edwdevops/table_limits_eod/intl_dash.csv
cat /var/groupon/edwdevops/table_limits_eod/deal_unity_map_mysql.csv /var/groupon/edwdevops/table_limits_eod/deal_unity_map_tdwc.csv|sort > /var/groupon/edwdevops/table_limits_eod/deal_unity_map.csv
sort /var/groupon/edwdevops/table_limits_eod/na_core_mysql.csv > /var/groupon/edwdevops/table_limits_eod/na_core.csv

pipeline_dt=`date --date="yesterday" "+%F"`
perc=$((100*$(cut -d, -f1 /var/groupon/edwdevops/table_limits_eod/na_core.csv /var/groupon/edwdevops/table_limits_eod/intl_dash.csv /var/groupon/edwdevops/table_limits_eod/deal_unity_map.csv|grep SUCCESS|wc -l)/$(cat /var/groupon/edwdevops/table_limits_eod/na_core.csv /var/groupon/edwdevops/table_limits_eod/intl_dash.csv /var/groupon/edwdevops/table_limits_eod/deal_unity_map.csv|wc -l)))
run_tm=`date '+%FT%TZ'`

echo "<html><title>EOD Table Limits</title><head><link rel="icon" href="favicon.png"></head><body>
<meta http-equiv="refresh" content="900">
<p style="display:inline">(Last refresh: </p>
<p style="display:inline" id="min_e"></p>
<p style="display:inline"> min back)
<br>EOD Table Limits status for ${pipeline_dt} - <b>${perc}% Completed</b></p>
<script>
var refresh_e = new Date('${run_tm}');
var now_e = new Date();
var diff_e = now_e - refresh_e;
var diff_min_e = Math.round(diff_e / 60000);
document.getElementById('min_e').innerHTML= diff_min_e;
</script>
<br>
<h2>North America</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>EOD Status</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Consistent_before_hard</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Table Name</b></th>
</tr>" > /var/groupon/edwdevops/table_limits_eod/tl_status.html
cat /var/groupon/edwdevops/table_limits_eod/na_core.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
echo "</table>" >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
echo "<h2>Citydeals</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>EOD Status</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Consistent_before_hard</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Table Name</b></th>
</tr>" >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
cat /var/groupon/edwdevops/table_limits_eod/intl_dash.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
echo "</table>" >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
echo "<h2>Deal Unity Map</h2>
<table border=2 cellpadding=3 cellspacing=2>
<tr>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>EOD Status</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Consistent_before_hard</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Table Name</b></th>
</tr>" >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
cat /var/groupon/edwdevops/table_limits_eod/deal_unity_map.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/table_limits_eod/tl_status.html
echo "</table></body></html>" >> /var/groupon/edwdevops/table_limits_eod/tl_status.html


sed -i -e 's/">SUCCESS/color:#000000" bgcolor="#01DF01">SUCCESS/g' /var/groupon/edwdevops/table_limits_eod/tl_status.html
sed -i -e 's/">FAILED/color:#000000" bgcolor="#FF0000">FAILED/g' /var/groupon/edwdevops/table_limits_eod/tl_status.html
