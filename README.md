# Samba
[![Docker Pulls](https://img.shields.io/docker/pulls/strm/samba.svg?style=plastic)](https://hub.docker.com/r/strm/samba/)
![License](https://img.shields.io/badge/License-GPL-blue.svg?style=plastic)

A very simple SAMBA file server in a container !

# Variables

- `Users` - The list of users (command separated) that will have access to the
  system.
- `Passwords` - For each user added to the system, create a variable with the
  username, the value of this variable will be the password.

# Shares

Shares follow the default samba configuration standard:

```
[Temp]
path = "/share/"
read only = no
writable = yes
valid users = opsxcq
write list = opsxcq
admin users = opsxcq
```

# Example docker-compose



```yml
version: "3"
services:

  samba:
    image: strm/samba
    environment:
      USERS: "opsxcq"
      opsxcq: "admin"
      SHARES_CONF: |
        [Temp]
        path = "/share/"
        read only = no
        writable = yes
        valid users = opsxcq
        write list = opsxcq
        admin users = opsxcq

    volumes:
      - "/tmp/:/share"
    ports:
      - 137:137/udp
      - 138:138/udp
      - 139:139
      - 445:455
      - 445:445/udp
```
