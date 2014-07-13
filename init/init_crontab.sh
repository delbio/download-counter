actual_dir=$(pwd)
command="bash $(dirname ${actual_dir})/download_counter_per_day.sh $1 \"1 days ago\""
job="10 00 * * * ${command}"
echo "$job"
#cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
crontab -l
