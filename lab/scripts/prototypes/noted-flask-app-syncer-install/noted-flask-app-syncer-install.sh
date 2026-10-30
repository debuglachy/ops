#!/bin/bash

# prepare system for user service
loginctl enable-linger $USER
mkdir -p /home/$USER/.config/systemd/user /home/$USER/mount

echo 'Available drives:'
echo
lsblk --output PATH | grep -e /dev/sd.[0-9] -e /dev/mmcblk.p[0-9]
echo 'Set drive path or press Enter for default [~/dev/sda1]: '
read DRIVESEL
DRIVESEL=${DRIVESEL:-/dev/sda1}
echo "$DRIVESEL  /home/$USER/mount  exfat  noauto,nofail,user,rw  0  0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
mount mount

# setting up dir containing notes
if [ -z "$MONOPATH" ]; then
        echo 'Set path or press Enter for default [~/noted-flask-app/notes-data/]:'
        read MONOPATH
        MONOPATH=${MONOPATH:-/home/$USER/noted-flask-app/notes-data/}
else
        echo 'Found environment variable to use.'
fi

! [ -d "$MONOPATH" ] && \
        { echo 'Not a valid directory';
        echo 'Usage $0: <directory>';
        exit 1; };

[[ "$MONOPATH" == "/" ]] && echo 'Root directory is not permitted' && exit 1

# generate user service
cat << EOF > /home/$USER/.config/systemd/user/noted-flask-app-syncer.service
[Unit]
Description=Syncs each file upon its creation

[Service]
Environment=MONOPATH=$MONOPATH
ExecStart=/bin/sh -c 'while inotifywait -e create $MONOPATH; do rsync $MONOPATH/* mount/; done;'

[Install]
WantedBy=default.target
EOF

systemctl --user enable --now noted-flask-app-syncer.service
