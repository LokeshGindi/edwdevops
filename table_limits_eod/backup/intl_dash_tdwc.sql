locking row for access sel case when cast ((consistent_before_hard- cast(minute_offset as interval minute)) as date) < current_date then 'FAILED' else 'SUCCESS' end as status, CAST(CAST(consistent_before_hard AS VARCHAR(19)) AS TIMESTAMP(0)), a.schema_name ||'/'|| a.table_name ||'/'|| a.content_group as tablename
from dwh_manage.table_limits_view a join dwh_manage.job_table_limits_map b on a.schema_name=b.schema_name and
a.table_name=b.tablename and (a.content_group=b.content_group or B.CONTENT_GROUP IS NULL) and b.jobid in (1, 2, 3, 9, 15, 114, 115, 117) and b. is_enabled = 'y' and consistent_before_hard < current_date+1 
union sel case when cast(consistent_before_hard as date) < current_date then 'FAILED' else 'SUCCESS' end as status, CAST(CAST(consistent_before_hard AS VARCHAR(19)) AS TIMESTAMP(0)), schema_name ||'/'|| table_name ||'/'|| content_group as tablename
from dwh_manage.table_limits_view where (
(schema_name='dwh_base' and TABLE_NAME='city_parts' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='deal_relations' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='deal_seo_categorie_map' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='deals_core' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='users' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='billings' and content_group='std_data')
or (schema_name='dwh_base' and TABLE_NAME='billings' and content_group='unity_int')
or (schema_name='dwh_base' and TABLE_NAME='merchants' and content_group in ('std_data','std_data_int'))) and consistent_before_hard < current_date+1;
