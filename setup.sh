#!/bin/bash
if [ "${PUBKEY}" = "" ] || [ "${USERNAME}" = "" ] || [ "${VHOSTNAME}" = "" ]; then
    echo "You need to specify a ssh PUBKEY, a USERNAME and VHOSTNAME"
    exit 1
fi

# Regenerate SSH keys
if [ -f "/root/.firstrun" ]; then
    rm /etc/ssh/ssh_host_*
    dpkg-reconfigure openssh-server
fi

# Install Docker and Buildstep Image
/usr/local/bin/wrapdocker
sleep 2
chmod 777 /var/run/docker.sock
if [ -f "/root/.firstrun" ]; then
    cat /root/buildstep.tar.gz | gunzip -cd | docker import - progrium/buildstep
fi

# Install remaining dokku stuff
if [ -f "/root/.firstrun" ]; then
    cd /root/dokku
    make sshcommand
    echo $PUBKEY | sshcommand acl-add dokku ${USERNAME}
    echo $VHOSTNAME > /home/dokku/VHOST
fi

# Start SSH and Nginx
service ssh start
service nginx start

if [ -f "/root/.firstrun" ]; then
    unlink /root/.firstrun
fi

# Open a shell
bash
