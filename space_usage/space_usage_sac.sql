SELECT trim(DatabaseName), cast(SUM(MaxPerm)/1024/1024/1024 as int) AS MAXSPACE
,cast((MAX(CurrentPerm) * (HASHAMP()+1))/1024/1024/1024 as int) AS USEDSPACE
,MAXSPACE-USEDSPACE AS REMAININGSPACE
,cast((cast(USEDSPACE as decimal(15,2))/MAXSPACE)*100 as int)   AS Percentage_Used, case when Percentage_Used <= 90 then 'SUCCESS' else 'FAILED' end as STATUS
FROM DBC.DiskSpace where databasename in ('dwh_base_staging','db_matt','poc', 'dw','prod_groupondw','staging','groupon_production','dwh_base','dwh_mart','meg_grp_prod','edwprod','dwh_manage')
GROUP BY 1 ORDER BY Percentage_Used DESC;
