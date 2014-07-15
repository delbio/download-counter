#!/bin/bash

min_args=1

if (( $# < ${min_args} ))
then
    echo "Errore config fie needed"
    echo "look config-sample.cfg for an example"
    exit
fi

set -e # exit on error

# Load config file -- http://wiki.bash-hackers.org/howto/conffile
configfile=${1}
configfile_secured='/tmp/cool.cfg'

if [ ! -f ${configfile} ]  # config file exist?
then
    echo "Error: ${configfile} not exist. Create it before"
    echo "look config-sample.cfg for an example"
    exit
fi

# check if the file contains something we don't want
if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
  echo "Config file is unclean, cleaning it..." >&2
  # filter the original to a new file
  egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
  configfile="$configfile_secured"
fi

# now source it, either the original or the filtered variant
source "$configfile"

date_row=${2}
date_request=$(date +%d/%b/%Y --date="${date_row}")

log_dir=$access_log_dir
log_file_name=$access_log_file

log_file=${log_dir}/${log_file_name}*

user=$db_user
user_pass=$db_pass
name_db=$db_name

patterns_string=$get
tables_name_string=$in_table

# Extract array from string
# http://stackoverflow.com/questions/10586153/bash-split-string-into-array

## declare an array variable
patterns=(${patterns_string//\ / })

## declare an array variable
table_names=(${tables_name_string//\ / })

# get length of an array
arraylength=${#patterns[@]}

# use for loop read all values and indexes
for (( i=1; i<${arraylength}+1; i++ ));
do

    echo "[" $i "/" ${arraylength} "] Count download di: ["${patterns[$i-1]}"] per il giorno: "${date_request}" ..."

    count=$(cat ${log_file} | grep ${patterns[$i-1]} | grep -c ${date_request})

    date_format_sql=$(date +%Y/%m/%d --date="${date_row}")
    echo "Result = { data: "${date_format_sql}", n_download: "${count} "}"

    # --- Salvataggio dei dati estratti nel db MySQL
    echo "save data in table "${table_names[$i-1]}

    # http://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
    if hash mysql 2>/dev/null; then

        sh save_to_mysql_table.sh ${user} ${user_pass} ${name_db} ${table_names[$i-1]} ${date_format_sql} ${count}

    else
        echo "mysql not installed"
    fi

    # --- Salvataggio dei dati in locale
    local_file=table_names[$i-1]}.csv
    echo "save data in local file: "${local_file}

    if [ ! -w ${local_file} ]  # is file writable?
    then
        echo ${date_format_sql}", "${count} >> ${local_file}
    else
        echo "Error: ${local_file} is not writable."
        echo "select another dir for file"
    fi
done


## USAGE: 
## bash download_counter_per_day.sh config.cfg "2014/06/09"
## bash download_counter_per_day.sh config.cfg "1 days ago"
