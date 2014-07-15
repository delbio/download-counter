How to use
================

Download Counter in Bash for small site

Creare il file di configurazione:
---------------------

Definisci il file di configurazione per il contatore:

    access_log_dir=/var/log/apache2
    access_log_file=access_file_name.log
    db_user=user
    db_pass=password
    db_name=database_name
    get=“file.txt app.apk"
    in_table=“table1 table2”

Salva i parametri in un file es: config.cfg

Inizializzare il db:
---------------

    cd init
    bash init_db.sh ../config.cfg init_db_file.sql


Come eseguire il contatore:
--------------
esegui il seguente comando per controllare il numero di download dei file: file.txt, app.apk di ieri

    bash download_counter_per_day.sh config.cfg "1 days ago"

Automatizzare il contatore via crontab:
----------
E' possibile automatizzare la creazione del cronjob eseguento i seguenti comandi:

    cd init
    bash init_crontab.sh /absolute/path/config.cfg

Per effettuare manualmente l'inserimento di un cronjob eseguire i seguenti passi:

Editare la lista di cron

    crontab -e

All'interno del file cron

    # Alle 00:10 di ogni giorno conta i download dei prodotti monitorari es: (nome-app.apk , nome-app2.apk)
    10 00 * * * cd /home/user/download-counter; bash download_counter_per_day.sh /home/user/config-sample.cfg "1 days ago"

Visualizzare il risultato delle letture:
---------
Visualizza i dowload giornalieri nella tabella associata al file:

    mysql -u user -p
    
inserisci la password (db_pass) per l'utente db_user
    
    USE database_name
    SHOW TABLES
    SELECT * FROM table1;
    SELECT * FROM table2;

