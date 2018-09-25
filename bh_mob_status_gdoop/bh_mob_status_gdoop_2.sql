/* 
select CONCAT('tracky_mob_extract',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from tracky_event_extract WHERE name like '%mobile%' and name not like '%MobileNotificationsStenoLogger' and name not like 'mobile_ab_experiment' and event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from tracky_event_extract WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null group by ref.name
union 
*/
select CONCAT('tracky_mob_load',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from steno_event_load WHERE name in ('dealview','pageview') and event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from steno_event_load WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null group by ref.name
order by ts;
