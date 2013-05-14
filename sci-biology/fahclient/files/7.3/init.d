#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

start() {
	ebegin "Starting Folding@home"

	start-stop-daemon --chdir /var/lib/fahclient --user foldingathome --nicelevel ${FAHCLIENT_NICE:-19} \
		--start --background --exec /opt/foldingathome/FAHClient -- --daemon --config "${FAHCLIENT_CONFIG}" \
		--pid-file "${FAHCLIENT_PIDFILE}" --log /var/lib/fahclient/log.txt ${FAHCLIENT_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping Folding@home"
	start-stop-daemon --stop --user foldingathome --pidfile "${FAHCLIENT_PIDFILE}"
#	if [ $? -ne 0 ]; then
#		killall --user foldingathome --signal SIGKILL
#		ewarn "killing all processes running as user 'foldingathome' ..."
#	fi
	eend $?
}
