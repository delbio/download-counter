min_args=1

if (( $# < ${min_args} ))
then
    echo "Error config.cfg file is needed"
    exit
fi

config_file=${1}

if [ ! -f $recipient_file ];
then
        echo "Selected Config file: $config_file not found"
        exit
fi

actual_dir=$(pwd)
command="cd $(dirname ${actual_dir}); bash download_counter_per_day.sh $config_file \"1 days ago\""
job="10 00 * * * ${command}"
echo "$job"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
crontab -l
