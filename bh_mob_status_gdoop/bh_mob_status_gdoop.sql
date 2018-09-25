select CONCAT('gdoop_bh_extract',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from tracky_event_extract WHERE event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from tracky_event_extract WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null group by ref.name
union
select CONCAT('gdoop_bh_parse',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from tracky_event_parser WHERE event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from tracky_event_parser WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null group by ref.name
union
select CONCAT('gdoop_bh_hive',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from bloodhound_clickstream_funnel WHERE event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from bloodhound_clickstream_funnel WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null group by ref.name
union
select CONCAT('gdoop_bh_td',': ',ref.name) as nm, min(timestamp(ref.dt) + interval ref.hr hour - interval 1 second) ts, TIMESTAMPDIFF(HOUR, min(timestamp(ref.dt) + interval ref.hr hour), current_timestamp) delta from
(select name,dt,hr from (select current_date as dt union select CURRENT_DATE- interval 1 day as dt union select CURRENT_DATE- interval 2 day as dt
union select CURRENT_DATE- interval 3 day as dt union select CURRENT_DATE- interval 4 day as dt union select CURRENT_DATE- interval 5 day as dt
union select CURRENT_DATE- interval 6 day as dt union select CURRENT_DATE- interval 7 day as dt union select CURRENT_DATE- interval 8 day as dt) dt_tbl join (select hr from tmp_hrs) hr_tbl join (select distinct name from bloodhound_clickstream_funnel_load WHERE event_date >= CURRENT_DATE- interval 8 day) namelist) ref
left outer join (select name, event_date, event_hour from bloodhound_clickstream_funnel_load WHERE event_date >= CURRENT_DATE- interval 8 day and status='SUCCEEDED') status on status.name=ref.name and status.event_date=ref.dt and status.event_hour=ref.hr
where status.name is null and ref.name not in ('widgets_core_cd','widgets_noncore_cd','widgets_core','widgets_noncore','checkout_noncore_cd','pageview_noncore_cd','click_noncore_cd')  group by ref.name
order by ts;
