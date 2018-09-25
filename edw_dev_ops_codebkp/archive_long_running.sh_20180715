#!/bin/bash
echo '<html>

<h2>Long Running Jobs History</h2>

<title>Long Running Jobs History</title>
<head><link rel="icon" href="favicon.png"></head>
<body bgcolor="#FFFFFF">
<meta http-equiv="refresh" content="900">
<font color="#000000" style="font-family:calibri;font-size:12px;"'>/var/groupon/edwdevops/long_running/archive.html

find /var/groupon/edwdevops/edw-dev-ops/archive/long_running -mtime +10 -delete

#Fetch list of old html files
for i in $(ls -lt /var/groupon/edwdevops/edw-dev-ops/archive/long_running/long_running_*.html|tr -s ' ' |cut -d' ' -f9) ; do
 file_name=$(basename $i)
 link_name=$(echo $file_name|tr -d ".html")
echo "<div>" >>/var/groupon/edwdevops/long_running/archive.html
echo "<p><a href="http://pit-prod-owagent3.snc1:8080/archive/long_running/$file_name" target="_blank">$file_name >></a></p>" >>/var/groupon/edwdevops/long_running/archive.html
echo "</div>" >>/var/groupon/edwdevops/long_running/archive.html

done

echo "</html>" >>/var/groupon/edwdevops/long_running/archive.html
