#!/bin/sh

chown -R www-data:www-data /srv/webvirtcloud
chown -R www-data:www-data /var/www/.ssh

DJANGO_PROJECT=/srv/webvirtcloud
PYTHON=$DJANGO_PROJECT/venv/bin/python3
LOG=/var/log/entrypoint.log

cd $DJANGO_PROJECT || exit

while true; do cd $DJANGO_PROJECT; venv/bin/gunicorn webvirtcloud.wsgi:application -c webvirtcloud/gunicorn.conf.py >> $LOG; sleep 10; done &

while true; do cd $DJANGO_PROJECT; . venv/bin/activate && console/socketiod -p 6081 -H 0.0.0.0 >> $LOG; sleep 10; done &

while true; do cd $DJANGO_PROJECT; . venv/bin/activate && console/novncd -k "$KVM_HOST" -p 6080 -H 0.0.0.0 -d >> $LOG; sleep 10; done &

exec /usr/sbin/nginx