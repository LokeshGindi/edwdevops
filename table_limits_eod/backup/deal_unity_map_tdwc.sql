sel case when cast(consistent_before_hard as date) < current_date then 'FAILED' else 'SUCCESS' end as status, CAST(CAST(consistent_before_hard AS VARCHAR(19)) AS TIMESTAMP(0)), schema_name ||'/'|| table_name ||'/'|| content_group as tablename
from dwh_manage.table_limits_view where (
(table_name='deal_unity_map' and schema_name='edwprod') or
(table_name in ('city_deals_ext','appdomains','deal_run_option','deal_template_option','deal_template') and schema_name = 'dwh_base'  and content_group = 'std_data')
) and consistent_before_hard<current_date+1;
