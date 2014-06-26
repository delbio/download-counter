user=${1}
pass=${2}
db_name=${3}
table=${4}
date=${5}
n_download=${6}

echo "INSERT INTO ${table} (date, download) VALUES" >> $HOME/line.sql
echo "('"$(date +%Y-%m-%d --date="${date}")"', '"${n_download}"');" >> $HOME/line.sql

mysql -u ${user} --password=${pass} ${db_name} < $HOME/line.sql
rm $HOME/line.sql
