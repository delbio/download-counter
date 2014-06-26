download-counter
================

Download Counter in Bash for small site

How to Use:

Definisci il file di configurazione per il contatore:

access_log_dir=/var/log/apache2
access_log_file=access_file_name.log
local_dir=/home/user/download-db
db_user=user
db_pass=password
db_name=database_name
get=“file.txt app.apk"
in_table=“table1 table2”

salva i parametri in un file es: config.cfg
esegui il seguente comando per controllare il numero di download dei file: file.txt, app.apk di ieri

bash download_counter_per_day.sh config.cfg "1 days ago"
