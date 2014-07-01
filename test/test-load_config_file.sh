# http://wiki.bash-hackers.org/howto/conffile
configfile=${1}
configfile_secured='/tmp/cool.cfg'

# check if the file contains something we don't want
if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
  echo "Config file is unclean, cleaning it..." >&2
  # filter the original to a new file
  egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
  configfile="$configfile_secured"
fi

# now source it, either the original or the filtered variant
echo "Reading user config...." >&2
source "$configfile"

echo "Config for the username: $access_log_dir" >&2
echo "Config for the username: $access_log_file" >&2
echo "Config for the username: $local_dir" >&2
echo "Config for the username: $db_user" >&2
echo "Config for the username: $db_pass" >&2
echo "Config for the username: $db_name" >&2
echo "Dove sono: ${0}" >&2

