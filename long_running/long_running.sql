     SELECT JOB_NAME, UPPER(SUBSTRING_INDEX(TASK_TYPE,'_',-1)) as TASK_TYPE, WK_FLOW, SUBSTRING(RUN_TIME,1,5) AS RUN_TIME, SUBSTRING(AVG_DURATION,1,5) AS AVG_DURTN FROM
     (SELECT
     EXEC.NAME AS JOB_NAME,
     EXEC.INVOKED_BY WK_FLOW,
     TIMEDIFF(COALESCE(EXEC.END_TIME,CURRENT_TIMESTAMP),EXEC.START_TIME) AS RUN_TIME,
     SEC_TO_TIME(AVG(TIME_TO_SEC(TIMEDIFF(EX.END_TIME,EX.START_TIME)))) AS AVG_DURATION,
     TIMEDIFF(TIMEDIFF(COALESCE(EXEC.END_TIME,CURRENT_TIMESTAMP),EXEC.START_TIME),SEC_TO_TIME(AVG(TIME_TO_SEC(TIMEDIFF(EX.END_TIME,EX.START_TIME))))) AS DIFFF,
     EXEC.SYS_CLASS_NAME AS TASK_TYPE
     FROM ops_exec EXEC
     LEFT OUTER JOIN
     ops_exec EX
     ON EXEC.TASK_ID=EX.TASK_ID
     AND EXEC.INVOKED_BY=EX.INVOKED_BY
     AND CAST(EX.START_TIME AS DATE)>=CURRENT_DATE - INTERVAL 14 DAY
     AND EX.END_TIME IS NOT NULL
     AND EX.STATUS_CODE=200
     AND EX.ATTEMPT_COUNT=1
     WHERE  EXEC.SYS_CLASS_NAME in ('ops_exec_unix','ops_exec_monitor')  AND
     CAST(EXEC.START_TIME AS DATE)>= ( CURRENT_DATE - INTERVAL 2 DAY) AND EXEC.END_TIME IS NULL
     GROUP BY 1,2 HAVING RUN_TIME > cast('00:30:00.000' as time) AND  DIFFF > cast('00:30:00.000' as time) )A
     ORDER by RUN_TIME DESC;
