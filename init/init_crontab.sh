command="php $INSTALL/indefero/scripts/gitcron.php"
job="5 0 * * 0 $command"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
