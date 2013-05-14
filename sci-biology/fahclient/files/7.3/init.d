#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

start() {
	ebegin "Starting Folding@home"

	start-stop-daemon --start --chdir /var/lib/fahclient --user foldingathome \
		--nicelevel ${FAHCLIENT_NICE:-19} --make-pidfile --pidfile "${FAHCLIENT_PIDFILE}" \
		--background --exec /opt/foldingathome/FAHClient -- --service --respawn \
		--config "${FAHCLIENT_CONFIG}" ${FAHCLIENT_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping Folding@home"
	start-stop-daemon --stop --user foldingathome --pidfile "${FAHCLIENT_PIDFILE}"
	eend $?
}
