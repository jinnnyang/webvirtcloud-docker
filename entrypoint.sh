#!/bin/sh

DJANGO_PROJECT=/srv/webvirtcloud
PYTHON=$DJANGO_PROJECT/venv/bin/python3
LOG=/var/log/entrypoint.log

cd $DJANGO_PROJECT || exit

RUNAS=$(which setuser)
[ -z "$RUNAS" ] && RUNAS="$(which sudo) -u"
USER=www-data

exec "$RUNAS" "$USER" "$PYTHON" "$DJANGO_PROJECT/console/novncd" "$PARAMS" >> $LOG &

exec $DJANGO_PROJECT/venv/bin/gunicorn webvirtcloud.wsgi:application -c $DJANGO_PROJECT/webvirtcloud/gunicorn.conf.py >> $LOG &

while true; do cd $DJANGO_PROJECT; . venv/bin/activate && console/socketiod; done &

exec /usr/sbin/nginx