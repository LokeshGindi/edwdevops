select case when consistent_before_hard < current_date then 'FAILED' else 'SUCCESS' end as status, consistent_before_hard, CONCAT(schema_name,'/',table_name,'/',content_group) as tablename
from dwh_manage.table_limits where (schema_name in ('Hive','Teradata') and table_name = 'dim_deal_unity');
