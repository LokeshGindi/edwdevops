#!/bin/bash
#extvar01=`sed -n 7,21p /var/groupon/edwdevops/edw-dev-ops/overall_pipeline.html`
#extvar01=`sed -n 6,21p /var/groupon/edwdevops/overall_pipeline/overall_pipeline_test.html`
t_value=`sed -n 6,21p /var/groupon/edwdevops/overall_pipeline/overall_pipeline_test.html|grep "EDW Pipeline Status"|cut -d'>' -f3|cut -d'%' -f1`
extvar01=`sed -n 6,21p /var/groupon/edwdevops/overall_pipeline/overall_pipeline_test.html| sed -e "s|: <b>|<progress max=100 value=t_value color=Green ></progress\>|" -e "s/t_value/$t_value/"`
#extvar02=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/bh_mob_status_gdoop.html`
##extvar02=`sed -n 6,21p /var/groupon/edwdevops/edw-dev-ops/bh_mob_status_gdoop_test.html`
extvar02=`sed -n 5,18p /var/groupon/edwdevops/bh_mob_status_gdoop/bh_mob_status_gdoop_test.html`
#extvar03=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/eod_table_limits.html`
##extvar03=`sed -n 6,21p /var/groupon/edwdevops/edw-dev-ops/eod_table_limits_test.html`
t_value=`sed -n 5,18p /var/groupon/edwdevops/table_limits_eod/tl_status_test.html|grep "Table Limits status"|cut -d'>' -f3|cut -d'%' -f1`
extvar03=`sed -n 5,18p /var/groupon/edwdevops/table_limits_eod/tl_status_test.html| sed -e "s|: <b>|<progress max=100 value=t_value color=Green ></progress\>|" -e "s/t_value/$t_value/"`
#extvar05=`sed -n 3,14p /var/groupon/edwdevops/edw-dev-ops/long_running.html`
extvar05=`sed -n 3,18p /var/groupon/edwdevops/long_running/long_running_test.html`
#extvar06=`sed -n 3,13p /var/groupon/edwdevops/edw-dev-ops/space_usage.html`
extvar06=`sed -n 3,20p /var/groupon/edwdevops/space_usage/space_usage_test.html`
extvar07=`cat /var/groupon/edwdevops/tdpass/tdpass.html`
awk -v var1="$extvar01" -v var2="$extvar02" -v var3="$extvar03" -v var5="$extvar05" -v var6="$extvar06" -v var7="$extvar07" '{ if($0=="extvar01") {print var1} else if($0=="extvar02") {print var2} else    if($0=="extvar03") {print var3} else if($0=="extvar05") {print var5} else if($0=="extvar06") {print var6} else if($0=="extvar07") {print var7} else {print $0} }' /var/groupon/edwdevops/overall_pipeline/index_template.html > /var/groupon/edwdevops/edw-dev-ops/index.html

date_range=$(cat $(ls -ltr /var/groupon/edwdevops/overall_pipeline/done/pipeline_metrics_*done|tail -7|tr -s ' ' |cut -d' ' -f9)|cut -d"|" -f1|sed 's/^/"/'|sed 's/$/",/'|tr -d "\n"|sed 's/,$//')
sla_values=$(cat $(ls -ltr /var/groupon/edwdevops/overall_pipeline/done/pipeline_metrics_*done|tail -7|tr -s ' ' |cut -d' ' -f9)|cut -d"|" -f2|sed 's/^/"/'|sed 's/$/",/'|tr -d "\n"|sed 's/,$//')
wkly_sla_perc=$(cat $(ls -ltr /var/groupon/edwdevops/overall_pipeline/done/pipeline_metrics_*done|tail -7|tr -s ' ' |cut -d' ' -f9)|cut -d"|" -f2|awk '{s+=$1} END {printf "%.0f\n", s*(1/7)}')
sed -i -e "s/date_range/$date_range/" -e "s/sla_values/$sla_values/" -e "s/wkly_sla_perc/$wkly_sla_perc/" /var/groupon/edwdevops/edw-dev-ops/index.html



