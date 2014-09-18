yum:
  lookup:
    rsync: /usr/bin/rsync
  repo:
    centos:
      base:
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        gpgcheck: True
        enable:
          base: True
          updates: True
          extras: True
          centosplus: False
          contrib: False
      debug:
        mirrorhost: debuginfo.centos.org
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6
        gpgcheck: True
        enable: True
    epel:
      mirrorlisthost: mirrors.fedoraproject.org
      gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
      gpgcheck: True
      enable: True
  mirror:
    user: root
    group: root
    require:
    mirrors:
      base:
        name: centos-base
        rsyncurl: rsync://mirrors.liquidweb.com/CentOS/
        rsyncopts: -avSHP --numeric-ids --delete --delete-delay --delay-updates
        path: /tmp/repos/centos
        enable: True
      epel:
        name: epel
        rsyncurl: rsync://mirrors.liquidweb.com/fedora-epel
        rsyncopts: -avSHP --numeric-ids --delete --delete-delay --delay-updates
        path: /tmp/repos/epel
        enable: True
