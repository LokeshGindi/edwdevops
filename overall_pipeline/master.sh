#!/bin/bash
extvar01=`sed -n 3,16p /var/groupon/edwdevops/edw-dev-ops/overall_pipeline.html`
extvar02=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/bh_mob_status_gdoop.html`
extvar03=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/eod_table_limits.html`
extvar05=`sed -n 3,14p /var/groupon/edwdevops/edw-dev-ops/long_running.html`
extvar06=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/space_usage.html`
extvar07=`cat /var/groupon/edwdevops/tdpass/tdpass.html`
awk -v var1="$extvar01" -v var2="$extvar02" -v var3="$extvar03" -v var5="$extvar05" -v var6="$extvar06" -v var7="$extvar07" '{ if($0=="extvar01") {print var1} else if($0=="extvar02") {print var2} else if($0=="extvar03") {print var3} else if($0=="extvar05") {print var5} else if($0=="extvar06") {print var6} else if($0=="extvar07") {print var7} else {print $0} }' /var/groupon/edwdevops/overall_pipeline/master_template.html > /var/groupon/edwdevops/edw-dev-ops/master.html

