#########################################
#LOAD GENERIC CONFIG FILES AND FUNCTIONS
#########################################
if [ -f /axp/gsn/gsnnexidia/app/vibes/conf/Generic_shell_v2.conf ]; then
	source /axp/gsn/gsnnexidia/app/vibes/conf/Generic_shell_v2.conf
	echo "Config file loaded"
else
	echo "  ****Error: /axp/gsn/gsnnexidia/app/vibes/conf/Generic_shell_v2.conf file not found"
	echo "  Exiting script....."
	exit -1
fi

logger_timestamp_start=date +'%Y-%m-%d-%H:%M:%S'
echo "Started vibes osat model output cstone v2 process: $logger_timestamp_start"

rundate=$1
echo "Run date provided from EE Node is: $rundate"

start_date=$2
end_date=$3

date=date +%Y-%m-%d
log_dt=$date

if [ -z $start_date ];then
	duration_in_hrs=8
	today_sys_date=date +"%Y-%m-%d %H:%M:%S.000"
	dt=date -d "$today_sys_date $duration_in_hrs hour ago" "+%Y-%m-%d"
	start_date="$dt 00:00:00.000"
	end_date="$date 23:59:59.999"
fi

lag=14
log_file="$c_USECASE_DEV/logs/vibes/vibes_osat_model_output_cstone_v2_$logger_timestamp_start.log"
feed_file_path="$c_USECASE_WAREHOUSE/dev/vibes/vibes_osat_model_output_cstone_v2"

echo "start_date: $start_date    end_date: $end_date " 

exec 3>&1 1>> $log_file  2>&1

# #--------------------------------------------------------------------------------------------------------------------------------
# # Trigger vibes gsn_vibes_model_sentiment_analysis file creation
# #--------------------------------------------------------------------------------------------------------------------------------
echo "$c_CLK_BIN -v -f $c_USECASE_APP/hql/vibes_osat_model_output_cstone_v2.hql -hiveconf hive_queue=$c_USECASE_QUEUE -hiveconf vibes_schema=$c_USECASE_DB -hiveconf start_date=$start_date -hiveconf end_date=$end_date "
#$c_CLK_BIN -v -f $c_USECASE_APP/hql/vibes_osat_model_output_cstone_v2.hql -hiveconf hive_queue="$c_USECASE_QUEUE" -hiveconf vibes_schema="$c_USECASE_DB"  -hiveconf start_date="$start_date" -hiveconf end_date="$end_date" -hiveconf cstone_schema="$c_CSTONE_DB" -hiveconf lag="$lag" >> $log_file

#$c_CLK_BIN -v -f $c_USECASE_APP/hql/vibes_osat_model_output_cstone_v2_lag.hql -hiveconf hive_queue="$c_USECASE_QUEUE" -hiveconf vibes_schema="$c_USECASE_DB" -hiveconf start_date="$start_date" -hiveconf end_date="$end_date" -hiveconf cstone_schema="certdb" -hiveconf lag="$lag" >> $log_file

$c_CLK_BIN -v -f $c_USECASE_APP/hql/vibes_osat_model_output_cstone_v2_lag.hql -hiveconf hive_queue="$c_USECASE_QUEUE" -hiveconf vibes_schema="$c_USECASE_DB" -hiveconf start_date="$start_date" -hiveconf end_date="$end_date" -hiveconf cstone_schema="cstonedb3" -hiveconf lag="$lag" >> $log_file

error_code=$?
logger_timestamp_end=date +'%Y-%m-%d-%H:%M:%S'

if [ $error_code -eq 0 ]; then
	echo "Hive load of ggsnnexidia_vibes_model_sentiment_analysis: Process completed successfully" 1>&3
else
	echo "Hive load of ggsnnexidia_vibes_model_sentiment_analysis: Process terminated with error code $error_code" 1>&3
	echo "Ended vibes_osat_model_output_cstone_v2 process: $logger_timestamp_end" 1>&3
	exit -1
fi
    
exit 0