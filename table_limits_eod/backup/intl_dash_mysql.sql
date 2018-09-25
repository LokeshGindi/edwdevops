select case when consistent_before_hard < current_date then 'FAILED' else 'SUCCESS' end as status, consistent_before_hard, CONCAT(schema_name,'/',table_name,'/',content_group) as tablename
from dwh_manage.table_limits where
(table_name='deals_core' and schema_name <> 'Teradata_tdwb') 
or (schema_name = 'snc1_teradata' AND table_name IN ('ext_payment','order_payment_transactions','orders','parent_orders','order_item_adjustments','order_item_units','order_payment_transactions','orders','parent_orders','order_item_adjustments','order_item_units'))
or (schema_name = 'Teradata' AND table_name IN ('billings'))
or (schema_name = 'Hive' and table_name IN ('deal_merch_product','deal_inv_product','deal_country_map','deal_window_map','dim_deal_unity'));
