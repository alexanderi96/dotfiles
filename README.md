File Manager:
-`autofs` for automatically performing mount operation

Edit `/etc/autofs/auto.master` and apped /media:

`/media  /etc/autofs/auto.media --timeout=10`

`--timeout=10` defines when to unmount inactive resource in seconds.

Create file `/etc/autofs/auto.media` with content:

`sdb1  -fstype=auto,async,nodev,user,noexec,nosuid,umask=002  :/dev/sdb1
sdb2  -fstype=auto,async,nodev,user,noexec,nosuid,umask=002  :/dev/sdb2
sdb3  -fstype=auto,async,nodev,user,noexec,nosuid,umask=002  :/dev/sdb3
sdb4  -fstype=auto,async,nodev,user,noexec,nosuid,umask=002  :/dev/sdb4`

and start autofs service.

`$ ln -s /etc/sv/autofs /var/service/`

-`Thunar` and `thunar-volman` to control removable devices
