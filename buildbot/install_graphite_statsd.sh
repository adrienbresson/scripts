#!/bin/bash

## Author : Adrien
## Date : 20130531 
## Installing Graphite 0.9.10 + StatsD 0.60 with apache2 + mysql on Debian squeeze/wheery (with deb packages)

## References:
#  http://www.tomas.cat/blog/en/installing-graphite-0910-debian-squeeze
#  http://blog.mapado.com/graphite-virtualenv-apache-symfony/
#  http://www.elao.com/blog/linux/install-stats-d-graphite-on-a-debian-server-to-monitor-a-symfony2-application-12.html
#  http://geek.michaelgrace.org/2011/09/how-to-install-graphite-on-ubuntu/
#  https://gist.github.com/jbraeuer/1715985

WORKING_DIR='/tmp/build'

## Install dependencies:
apt-get install rubygems
apt-get install python-twisted
apt-get install python-setuptools
apt-get install python-pip
apt-get install python-whisper
apt-get install build-essential libopenssl-ruby ruby1.8-dev
apt-get install python-mysqldb
apt-get install libapache2-mod-wsgi

## Install Effing Package Management (fpm) to build packages
gem install fpm 
 
## Get sources (carbon, whisper, graphite)
mkdir -p ${WORKING_DIR}
cd ${WORKING_DIR} 
wget http://pypi.python.org/packages/source/c/carbon/carbon-0.9.10.tar.gz
wget http://pypi.python.org/packages/source/w/whisper/whisper-0.9.10.tar.gz
wget http://pypi.python.org/packages/source/g/graphite-web/graphite-web-0.9.10.tar.gz
tar xzf graphite-web-0.9.10.tar.gz
tar xzf carbon-0.9.10.tar.gz
tar xzf whisper-0.9.10.tar.gz

## With debian squeeze python2.6 is used so I made a dirty postinst in order to symlink whisper (I should fix this, but wheezy is now stable)
echo '#!/bin/bash

ln -sf /usr/local/lib/python2.7/dist-packages/whisper.pyc /usr/lib/python2.6/whisper.pyc
ln -sf /usr/local/lib/python2.7/dist-packages/whisper.py /usr/lib/python2.6/whisper.py' > ${WORKING_DIR}/graphite_postinst.sh

## Build python packages with fpm 
fpm --after-install ${WORKING_DIR}/graphite_postinst.sh --python-install-lib /opt/graphite/webapp -s python -t deb -d "python" -d "apache2" -d "python-twisted" -d "python-memcache" -d "libapache2-mod-python" -d "python-django" -d "libpixman-1-0" -d "python-cairo" -d "python-django-tagging" -d "python-mysqldb" -d "libapache2-mod-wsgi" graphite-web-0.9.10/setup.py
fpm --python-install-bin /opt/graphite/bin -s python -t deb carbon-0.9.10/setup.py
fpm --python-install-bin /opt/graphite/bin  -s python -t deb whisper-0.9.10/setup.py

## Note : To add init.d scripts edit setup.py 
# init = [ ('/etc/init.d/', glob('init.d/*')) ]

## Get sources (nodejs)
git clone https://github.com/joyent/node.git
cd node
git checkout v0.8.12

## Build make package with fpm
./configure --prefix=/usr
make
mkdir -p ${WORKING_DIR}/nodejs_build/
make install DESTDIR=/tmp/installdir
fpm -s dir -t deb -n nodejs -v 0.8.12 -C ${WORKING_DIR}/nodejs_build/ -p nodejs-0.8.12_all.deb -d "libssl0.9.8 (> 0)" -d "libstdc++6 (>= 4.4.3)"  usr/bin usr/lib
cd -

## Get sources (statsD)
git clone https://github.com/etsy/statsd
cd statsd/
cp exampleConfig.js local.js
cd -

## Build npm package with fpm
fpm -s npm -t deb statsd/

## Install packages
dpkg -i python-carbon_0.9.10_all.deb
dpkg -i python-graphite-web_0.9.10_all.deb
dpkg -i python-whisper_0.9.10_all.deb
dpkg -i nodejs-0.8.12_all.deb
dpkg -i node-statsd_0.6.0_amd64.deb
apt-get install -f


## Graphite apache2 conf (which I added to the package)
#<VirtualHost *:80>
#    ServerName  graphite.ab
#
#    DocumentRoot "/opt/graphite/webapp"
#
#    WSGIDaemonProcess graphite processes=5 threads=5 display-name='%{GROUP}' inactivity-timeout=120
#    WSGIProcessGroup graphite
#    WSGIApplicationGroup %{GLOBAL}
#    WSGIImportScript /opt/graphite/conf/graphite.wsgi process-group=graphite application-group=%{GLOBAL}
#
#    WSGIScriptAlias / /opt/graphite/conf/graphite.wsgi
#
#    <Directory />
#        Options FollowSymLinks
#        AllowOverride All
#    </Directory>
#
#    Alias /content/ /opt/graphite/webapp/content/
#    <Location "/content/">
#            SetHandler None
#    </Location>
#
#    Alias /media/ "@DJANGO_ROOT@/contrib/admin/media/"
#    <Location "/media/">
#            SetHandler None
#    </Location>
#
#    # The graphite.wsgi file has to be accessible by apache. It will not
#    # be visible to clients because of the DocumentRoot though.
#    <Directory /opt/graphite/conf/>
#            Order deny,allow
#            Allow from all
#    </Directory>
#</VirtualHost>

## graphite-carbon init script (which I added to the package)
##!/bin/bash
##
## Carbon (part of Graphite)
##
## chkconfig: 3 50 50
## description: Carbon init.d
#. /lib/lsb/init-functions
#prog=carbon
#RETVAL=0
#
#start() {
#        log_progress_msg "Starting $prog: "
#
#        PYTHONPATH=/usr/local/lib/python2.7/dist-packages/ /opt/graphite/bin/carbon-cache.py start
#        status=$?
#        log_end_msg $status
#}
#
#stop() {
#        log_progress_msg "Stopping $prog: "
#
#        PYTHONPATH=/usr/local/lib/python2.7/dist-packages/ /opt/graphite/bin/carbon-cache.py stop > /dev/null 2>&1
#        status=$?
#        log_end_msg $status
#}
#
## See how we were called.
#case "$1" in
#  start)
#        start
#        ;;
#  stop)
#        stop
#        ;;
#  status)
#        PYTHONPATH=/usr/local/lib/python2.7/dist-packages/ /opt/graphite/bin/carbon-cache.py status
#        RETVAL=$?
#        ;;
#  restart)
#        stop
#        start
#        ;;
#  *)
#        echo $"Usage: $prog {start|stop|restart|status}"
#        exit 1
#esac
#
#exit $RETVAL


## StatsD init script (wich I added to the package)
##! /bin/sh
#
## Do NOT "set -e"
#
#
#if [ -x /usr/local/bin/node ];then
#        NODE_BIN=/usr/local/bin/node
#elif [ -x /usr/bin/nodejs ]; then
#        NODE_BIN=/usr/bin/nodejs
#elif [ -x /usr/bin/node ]; then
#        NODE_BIN=/usr/bin/node
#else
#        echo "Can't find /usr/bin/nodejs or /usr/bin/node"
#        exit 1
#fi
#
## PATH should only include /usr/* if it runs after the mountnfs.sh script
#PATH=/sbin:/usr/sbin:/bin:/usr/bin
#DESC="StatsD"
#NAME=statsd
#DAEMON=$NODE_BIN
##DAEMON_ARGS="/usr/share/statsd/stats.js /etc/statsd/rdioConfig.js 2>&1 >> /var/log/statsd/statsd.log "
#DAEMON_ARGS="/usr/local/lib/node_modules/statsd/stats.js /usr/local/lib/node_modules/statsd/local.js 2>&1 >> /var/log/statsd/statsd.log "
#PIDFILE=/var/run/$NAME.pid
#SCRIPTNAME=/etc/init.d/$NAME
#
## Exit if the package is not installed
## [ -x "$DAEMON" ] || exit 0
#
## Read configuration variable file if it is present
#[ -r /etc/default/$NAME ] && . /etc/default/$NAME
#
## Load the VERBOSE setting and other rcS variables
#. /lib/init/vars.sh
#
## Define LSB log_* functions.
## Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
#. /lib/lsb/init-functions
#
##
## Function that starts the daemon/service
##
#do_start()
#{
#	# Return
#	#   0 if daemon has been started
#	#   1 if daemon was already running
#	#   2 if daemon could not be started
#	start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON --test > /dev/null \
#		|| return 1
#	start-stop-daemon --start --quiet -m --pidfile $PIDFILE --startas $DAEMON --background -- \
#		$DAEMON_ARGS > /dev/null 2> /var/log/$NAME-stderr.log \
#		|| return 2
#	# Add code here, if necessary, that waits for the process to be ready
#	# to handle requests from services started subsequently which depend
#	# on this one.  As a last resort, sleep for some time.
#}
#
##
## Function that stops the daemon/service
##
#do_stop()
#{
#	# Return
#	#   0 if daemon has been stopped
#	#   1 if daemon was already stopped
#	#   2 if daemon could not be stopped
#	#   other if a failure occurred
#	start-stop-daemon --stop --quiet --retry=0/0/KILL/5 --pidfile $PIDFILE 
#	RETVAL="$?"
#	[ "$RETVAL" = 2 ] && return 2
#	# Wait for children to finish too if this is a daemon that forks
#	# and if the daemon is only ever run from this initscript.
#	# If the above conditions are not satisfied then add some other code
#	# that waits for the process to drop all resources that could be
#	# needed by services started subsequently.  A last resort is to
#	# sleep for some time.
#	start-stop-daemon --stop --quiet --oknodo --retry=0/30/KILL/5 --exec $DAEMON
#	[ "$?" = 2 ] && return 2
#	# Many daemons don't delete their pidfiles when they exit.
#	rm -f $PIDFILE
#	return "$RETVAL"
#}
#
##
## Function that sends a SIGHUP to the daemon/service
##
#do_reload() {
#	#
#	# If the daemon can reload its configuration without
#	# restarting (for example, when it is sent a SIGHUP),
#	# then implement that here.
#	#
#	start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE --name $NAME
#	return 0
#}
#
#case "$1" in
#  start)
#	[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
#	do_start
#	case "$?" in
#		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
#		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
#	esac
#	;;
#  stop)
#	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
#	do_stop
#	case "$?" in
#		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
#		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
#	esac
#	;;
#  #reload|force-reload)
#	#
#	# If do_reload() is not implemented then leave this commented out
#	# and leave 'force-reload' as an alias for 'restart'.
#	#
#	#log_daemon_msg "Reloading $DESC" "$NAME"
#	#do_reload
#	#log_end_msg $?
#	#;;
#  restart|force-reload)
#	#
#	# If the "reload" option is implemented then remove the
#	# 'force-reload' alias
#	#
#	log_daemon_msg "Restarting $DESC" "$NAME"
#	do_stop
#	case "$?" in
#	  0|1)
#		do_start
#		case "$?" in
#			0) log_end_msg 0 ;;
#			1) log_end_msg 1 ;; # Old process is still running
#			*) log_end_msg 1 ;; # Failed to start
#		esac
#		;;
#	  *)
#	  	# Failed to stop
#		log_end_msg 1
#		;;
#	esac
#	;;
#  *)
#	#echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
#	echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
#	exit 3
#	;;
#esac

