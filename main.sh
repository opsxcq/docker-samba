#!/bin/bash

if [[ -z "${WORKGROUP}" ]]
then
  export WORKGROUP="WORKGROUP"
fi

if [[ -z "${USERS}" ]]
then
  echo '[-] Please inform the users in the USER variable'
  echo '[-] Creating a default username, this is dangerous'
  export USERS=admin
  export admin=admin
fi

for username in $(echo $USERS | tr ',' '\n')
do
    password=${!username}
    (sleep 1;echo "$password"; sleep 1;echo "$password") | adduser $username
    (sleep 1;echo "$password"; sleep 1;echo "$password") | smbpasswd -a -s -c /etc/samba/smb.conf $username
done

cat > "/etc/samba/smb.conf" <<EOF
[global]
workgroup = ${WORKGROUP}
netbios name = ${HOSTNAME}
server string = ${HOSTNAME}
security = user
create mask = 0664
directory mask = 0775
force create mode = 0664
force directory mode = 0775
load printers = no
printing = bsd
printcap name = /dev/null
guest account = nobody
max log size = 50
map to guest = bad user
dns proxy = yes

vfs objects = fruit streams_xattr

local master = yes
read raw = yes
socket options = TCP_NODELAY SO_KEEPALIVE SO_RCVBUF=131072 SO_SNDBUF=131072

aio read size = 16384
aio write size = 16384

case sensitive = no
getwd cache = yes
preserve case = yes
short preserve case = yes

${SHARES_CONF}

EOF

nmbd -D
exec ionice -c 3 smbd -FS --configfile=/etc/samba/smb.conf < /dev/null
