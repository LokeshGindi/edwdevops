#!/bin/bash
if [ -n "$1" ]; then email_list=$1; else email_list="edw-dev-ops@groupon.com"; fi

mysql -hprod-pitstop-rw-vip.us.daas.grpn -uedw_user -pedw_password -Dedw </var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.sql|tr '\t' ,|tail -n +2 > /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop_1.csv
#mysql -hprod-pitstop-rw-vip.us.daas.grpn -utracky -pbloodhound tracky </var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop_2.sql|tr '\t' ,|tail -n +2 > /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop_2.csv
sort -t, -k3nr,3 /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop_[1].csv|awk 'BEGIN{FS=OFS=","} {if ($3>7) print $0,"FAILED"; else print $0,"SUCCESS"}' > /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.csv

echo "From:edw-dev-ops@groupon.com
To:${email_list}
Subject: FAILED- Hourly BH/Mobile Status
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
<html><body>
<p>Please check- <a href="http://pit-prod-owagent3.snc1:8080/bh_mob_status_gdoop.html" target="_blank">Hourly BH/Mobile Status >></a></p>
</body></html>" > /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_email.html


max_hr=`cut -d, -f2 /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.csv|head -1`
max_delta=`cut -d, -f3 /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.csv|head -1`
run_tm=`date '+%FT%TZ'`

echo "<html><title>Hourly BH/Mobile Status</title><head><link rel="icon" href="favicon.png"></head><body>
<meta http-equiv="refresh" content="900">
<p style="display:inline">(Last refresh: </p>
<p style="display:inline" id="min_g"></p>
<p style="display:inline"> min back)
<br>Hourly BH/Mobile Status- Load completed till <b>${max_hr}</b></p>
<script>
var refresh_g = new Date('${run_tm}');
var now_g = new Date();
var diff_g = now_g - refresh_g;
var diff_min_g = Math.round(diff_g / 60000);
document.getElementById('min_g').innerHTML= diff_min_g;
</script>
<table border=2 cellpadding=3 cellspacing=2>
<tr style="font-size:12px">
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Event Name</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Consistent Before</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Delta (in hours)</b></th>
  <th align=center style=white-space:nowrap bgcolor=#C0C0C0><b>Status (Delta<8)</b></th>
</tr>" > /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.html
cat /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.csv|sed -e 's/$/<\/td><\/tr>/g' -e 's/^/<tr style="font-size:12px"><td align="center" style="white-space:nowrap;">/g' -e 's/,/<\/td><td align="center" style="white-space:nowrap;">/g' >> /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.html
echo "</table></body></html>" >> /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.html

sed -i -e 's/">SUCCESS/color:#000000" bgcolor="#01DF01">SUCCESS/g' /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.html
sed -i -e 's/">FAILED/color:#000000" bgcolor="#FF0000">FAILED/g' /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop.html

if [ ${max_delta}  -ge 8 ]
then
cat /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_email.html|sendmail ${email_list}
fi
