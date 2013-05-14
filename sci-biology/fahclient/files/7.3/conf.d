# Config file for /etc/init.d/fahclient
#
# The Folding@home client configuration can be found in /etc/fahclient/config.xml
#
# The options that may be passed to the Folding client can be obtained
# by running FAHClient --help
#
FAHCLIENT_OPTS=""

# Nice level can be overridden by setting FAHCLIENT_NICE. Defaults to 19 if unset.
#
# FAHCLIENT_NICE=0

FAHCLIENT_CONFIG=/etc/fahclient/config.xml

FAHCLIENT_PIDFILE=/run/fahclient.pid
