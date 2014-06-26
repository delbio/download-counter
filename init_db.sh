#!/bin/bash

# Load config file -- http://wiki.bash-hackers.org/howto/conffile
configfile=${1}
init_db_sql_file=${2}
configfile_secured='/tmp/cool.cfg'


# check if the file contains something we don't want
if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
  echo "Config file is unclean, cleaning it..." >&2
  # filter the original to a new file
  egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
  configfile="$configfile_secured"
fi

# now source it, either the original or the filtered variant
source "$configfile"

user=$db_user
user_pass=$db_pass
name_db=$db_name

tables_name_string=$in_table

# Extract array from string
# http://stackoverflow.com/questions/10586153/bash-split-string-into-array

## declare an array variable
table_names=(${tables_name_string//\ / })

# get length of an array
arraylength=${#table_names[@]}

rm ${init_db_sql_file}

# Create DB if not esist
echo "Create DB ..."
echo "CREATE DATABASE IF NOT EXISTS ${name_db};" >> ${init_db_sql_file}

echo "USE ${name_db};" >> ${init_db_sql_file}

# use for loop read all values and indexes
for (( i=1; i<${arraylength}+1; i++ ));
do

    echo "[" $i "/" ${arraylength} "] Create table ${table_names[$i-1]} in DB ${name_db} ..."
    echo "CREATE TABLE IF NOT EXISTS ${table_names[$i-1]} (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, date DATE, download INT);" >> ${init_db_sql_file}

done

echo "CREATE USER '${user}'@'localhost' IDENTIFIED BY '${user_pass}';" >> ${init_db_sql_file}
echo "GRANT INSERT, UPDATE, DELETE, SELECT ON ${name_db}.* TO '${user}'@localhost’;" >> ${init_db_sql_file}
echo "FLUSH PRIVILEGES;" >> ${init_db_sql_file}

# get input from user
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html

echo  "You want to init db, tables and user to MySQL? type [Y/n] followed by [ENTER]: "

read isYes

case "$isYes" in
'Y')
    echo "yes";;
    mysql -u ${user} --password=${user_pass} < ${init_db_sql_file} && rm ${init_db_sql_file} 
    
*)
    #do_nothing;i ;

esac

