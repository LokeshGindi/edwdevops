sel databasename, cast(passwordmodtime as date)+ interval '89' day - current_date as exp_days from dbc.dbase
where (ownername in ('p_etlbatch','p_datamover') or databasename='b_emailetl')  and exp_days<=15 order by 2;
