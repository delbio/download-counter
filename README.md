How to use
================

Download Counter in Bash for small site

Creare il file di configurazione:
---------------------

Definisci il file di configurazione per il contatore:

    access_log_dir=/var/log/apache2
    access_log_file=access_file_name.log
    local_dir=/home/user/download-counter
    db_user=user
    db_pass=password
    db_name=database_name
    get=“file.txt app.apk"
    in_table=“table1 table2”

Salva i parametri in un file es: config.cfg

Inizializzare il db:
---------------

    bash init_db.sh config.cfg init_db_file.sql


Come eseguire il contatore:
--------------
esegui il seguente comando per controllare il numero di download dei file: file.txt, app.apk di ieri

    bash download_counter_per_day.sh config.cfg "1 days ago"

Automatizzare il contatore via crontab:
----------

Editare la lista di cron

    crontab -e

All'interno del file cron

    # Alle 00:10 di ogni giorno conta i download dei prodotti monitorari es: (nome-app.apk , nome-app2.apk)
    10 00 * * * bash /home/user/download-counter/download_counter_per_day.sh /home/user/config.cfg "1 days ago"
