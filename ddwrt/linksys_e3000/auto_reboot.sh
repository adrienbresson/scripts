#!/bin/sh

# Date        : 20130605
# Autho       : Adrien 
# Description : Auto reboot dd-wrt router each night at 5 AM
#               When my router is up since a long time WIFI as poor performance
#               I didn't found where the bug is comming from
#               As a workaround I write this script

command='#!/bin/sh\nstartservice run_rc_shutdown\n/sbin/reboot'
restartScript='/tmp/restart_router.sh'
cronJob="0 5 * * * root ${restartScript} > /dev/null 2>&1"
cronD='/tmp/cron.d/restartrouter'

echo -e "${command}" > ${restartScript}
chmod a+x ${restartScript}
echo "${cronJob}" > ${cronD}

