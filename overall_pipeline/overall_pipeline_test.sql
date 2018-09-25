select 'zendesk_international' as subject, 'DLY_ZENDESK_INTL_NEW' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '06:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('06:00')),':',2) as timediff, case when TIME_TO_SEC('06:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('06:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_ZENDESK_INTL_NEW_$%' or name like 'DLY_ZENDESK_INTL_NEW_201%' or            name='DLY_ZENDESK_INTL_NEW') and cast(trigger_time as date)=current_date;
select 'mobile' as subject, 'LOAD_DIM_MOBILE_USER_DEVICE' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '07:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('07:00')),':',2) as timediff, case when TIME_TO_SEC('07:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('07:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'LOAD_DIM_MOBILE_USER_DEVICE_$%' or name like 'LOAD_DIM_MOBILE_USER_DEVICE_201%' or            name='LOAD_DIM_MOBILE_USER_DEVICE') and cast(trigger_time as date)=current_date;
select 'attribution_janus' as subject, 'DLY_ATTRIBUTION_JANUS' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '09:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('09:00')),':',2) as timediff, case when TIME_TO_SEC('09:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('09:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_ATTRIBUTION_JANUS_$%' or name like 'DLY_ATTRIBUTION_JANUS_201%' or            name='DLY_ATTRIBUTION_JANUS') and cast(trigger_time as date)=current_date;
select 'fact_collections' as subject, 'LOAD_FACT_COLLECTIONS_MV' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '09:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('09:00')),':',2) as timediff, case when TIME_TO_SEC('09:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('09:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'LOAD_FACT_COLLECTIONS_MV_$%' or name like 'LOAD_FACT_COLLECTIONS_MV_201%' or            name='LOAD_FACT_COLLECTIONS_MV') and cast(trigger_time as date)=current_date;
select 'sf_upload' as subject, 'DLY_SF_UPLOAD' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '10:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('10:00')),':',2) as timediff, case when TIME_TO_SEC('10:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('10:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_SF_UPLOAD_$%' or name like 'DLY_SF_UPLOAD_201%' or            name='DLY_SF_UPLOAD') and cast(trigger_time as date)=current_date;
select 'attr_1_sub' as subject, 'DLY_ATTRIBUTION_3.0_INTL_SUB' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '10:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('10:00')),':',2) as timediff, case when TIME_TO_SEC('10:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('10:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_ATTRIBUTION_3.0_INTL_SUB_$%' or name like 'DLY_ATTRIBUTION_3.0_INTL_SUB_201%' or            name='DLY_ATTRIBUTION_3.0_INTL_SUB') and cast(trigger_time as date)=current_date;
select 'gbl_superfunnel_core' as subject, 'DLY_JANUS_SUPER_FUNNEL' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '10:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('10:00')),':',2) as timediff, case when TIME_TO_SEC('10:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('10:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_JANUS_SUPER_FUNNEL_$%' or name like 'DLY_JANUS_SUPER_FUNNEL_201%' or            name='DLY_JANUS_SUPER_FUNNEL') and cast(trigger_time as date)=current_date;
select 'gbl_email_impression_agg' as subject, 'DLY_GBL_EMAIL_IMPRESSION_AGG' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '10:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('10:00')),':',2) as timediff, case when TIME_TO_SEC('10:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('10:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_GBL_EMAIL_IMPRESSION_AGG_$%' or name like 'DLY_GBL_EMAIL_IMPRESSION_AGG_201%' or            name='DLY_GBL_EMAIL_IMPRESSION_AGG') and cast(trigger_time as date)=current_date;
select 'agg_gbl_impressions_deal' as subject, 'DLY_GPR2.1_AGG_GBL_IMPRESSIONS' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '11:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('11:00')),':',2) as timediff, case when TIME_TO_SEC('11:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('11:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_GPR2.1_AGG_GBL_IMPRESSIONS_$%' or name like 'DLY_GPR2.1_AGG_GBL_IMPRESSIONS_201%' or            name='DLY_GPR2.1_AGG_GBL_IMPRESSIONS') and cast(trigger_time as date)=current_date;
select 'agg_gbl_traffic' as subject, 'DLY_GPR2.1_TRAFFIC_COPY_CEREBRO' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '11:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('11:00')),':',2) as timediff, case when TIME_TO_SEC('11:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('11:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_GPR2.1_TRAFFIC_COPY_CEREBRO_$%' or name like 'DLY_GPR2.1_TRAFFIC_COPY_CEREBRO_201%' or            name='DLY_GPR2.1_TRAFFIC_COPY_CEREBRO') and cast(trigger_time as date)=current_date;
select 'zendesk_us' as subject, 'DLY_ZENDESK_US' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '11:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('11:00')),':',2) as timediff, case when TIME_TO_SEC('11:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('11:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_ZENDESK_US_$%' or name like 'DLY_ZENDESK_US_201%' or            name='DLY_ZENDESK_US') and cast(trigger_time as date)=current_date;
select 'agg_search' as subject, 'DLY_SEARCH_AGG_JANUS_FULL_WF' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '12:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('12:00')),':',2) as timediff, case when TIME_TO_SEC('12:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('12:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_SEARCH_AGG_JANUS_FULL_WF_$%' or name like 'DLY_SEARCH_AGG_JANUS_FULL_WF_201%' or            name='DLY_SEARCH_AGG_JANUS_FULL_WF') and cast(trigger_time as date)=current_date;
select 'agg_gbl_financials' as subject, 'DLY_GPR2.0_FINANCE_COPY_CEREBRO' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '13:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('13:00')),':',2) as timediff, case when TIME_TO_SEC('13:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('13:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_GPR2.0_FINANCE_COPY_CEREBRO_$%' or name like 'DLY_GPR2.0_FINANCE_COPY_CEREBRO_201%' or            name='DLY_GPR2.0_FINANCE_COPY_CEREBRO') and cast(trigger_time as date)=current_date;
select 'fact_gbl_transactions' as subject, 'CEREBRO_GDOOP_COPY_FACT_GBL_TRANSACTIONS_SOX_WF' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '13:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('13:00')),':',2) as timediff, case when TIME_TO_SEC('13:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('13:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'CEREBRO_GDOOP_COPY_FACT_GBL_TRANSACTIONS_SOX_WF_$%' or name like 'CEREBRO_GDOOP_COPY_FACT_GBL_TRANSACTIONS_SOX_WF_201%' or            name='CEREBRO_GDOOP_COPY_FACT_GBL_TRANSACTIONS_SOX_WF') and cast(trigger_time as date)=current_date;
select 'gbl_dim_Deal' as subject, 'DLY_GBL_CEREBRO_COPY' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '13:00' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('13:00')),':',2) as timediff, case when TIME_TO_SEC('13:00') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('13:00') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_GBL_CEREBRO_COPY_$%' or name like 'DLY_GBL_CEREBRO_COPY_201%' or            name='DLY_GBL_CEREBRO_COPY') and cast(trigger_time as date)=current_date;
select 'mobile_push_notification' as subject, 'DLY_MOBILE_PUSH_NOTIFICATION' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '14:30' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('14:30')),':',2) as timediff, case when TIME_TO_SEC('14:30') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('14:30') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_MOBILE_PUSH_NOTIFICATION_$%' or name like 'DLY_MOBILE_PUSH_NOTIFICATION_201%' or            name='DLY_MOBILE_PUSH_NOTIFICATION') and cast(trigger_time as date)=current_date;
select 'mobile_engagement_emea' as subject, 'DLY_MOBILE_PUSH_NOTIFICATION_EMEA' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '14:30' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('14:30')),':',2) as timediff, case when TIME_TO_SEC('14:30') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('14:30') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_MOBILE_PUSH_NOTIFICATION_EMEA_$%' or name like 'DLY_MOBILE_PUSH_NOTIFICATION_EMEA_201%' or            name='DLY_MOBILE_PUSH_NOTIFICATION_EMEA') and cast(trigger_time as date)=current_date;
select 'goods_agg' as subject, 'DLY_LOAD_GOODS_DAY_DEAL' as jobname, case status_code when 200 then 'SUCCESS' when 190 then 'FINISHED' when 80 then 'RUNNING' when 140 then ' FAILED' when 81 then ' FAILED' else ' WAITING' end as jobstatus, DATE_FORMAT(case when status_code=200 then end_time end, '%H:%i') as endtime, '15:30' as sla,                                  SUBSTRING_INDEX(SEC_TO_TIME(TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME()))-TIME_TO_SEC('15:30')),':',2) as timediff, case when TIME_TO_SEC('15:30') -                 TIME_TO_SEC(coalesce(time(case when status_code=200 then end_time end),CURTIME())) < -630 then 'DELAYED' else case when case when status_code=200 then end_time end is not null then 'ON-TIME' else case when  TIME_TO_SEC('15:30') - TIME_TO_SEC(CURTIME()) <= 3600 then 'NEAR DELAYED' else NULL end end end as delaystatus from ops_exec where (name like 'DLY_LOAD_GOODS_DAY_DEAL_$%' or name like 'DLY_LOAD_GOODS_DAY_DEAL_201%' or            name='DLY_LOAD_GOODS_DAY_DEAL') and cast(trigger_time as date)=current_date;
