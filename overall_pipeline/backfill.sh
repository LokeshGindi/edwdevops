for i in $(seq  60 -1 1) ; do
sh overall_pipeline.sh_bkp_config -lookback_days $i -backfill_flag Y
if [[ $? -eq 0 ]] ; then
 echo "$i - Done"
fi
done

