yum:
  lookup:
    rsync: /usr/bin/rsync
  repo:
    centos:
      os:
        mirrorurl: 
        mirrorhost: 
        mirrorlisturl: 
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        gpgcheck: True
        enable: True
      updates:
        mirrorurl: 
        mirrorhost: 
        mirrorlisturl: 
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        enable: True
      extras:
        mirrorurl: 
        mirrorhost: 
        mirrorlisturl: 
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        enable: True
      centosplus:
        mirrorurl: 
        mirrorhost: 
        mirrorlisturl: 
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        enable: False
      contrib:
        mirrorurl: 
        mirrorhost: 
        mirrorlisturl: 
        mirrorlisthost: 'mirrorlist.centos.org'
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
        enable: False
      debug:
        mirrorurl: 
        mirrorhost: debuginfo.centos.org
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6
        gpgcheck: True
        enable: True
    epel:
      mirrorurl: 
      mirrorhost:
      mirrorlisturl: 
      mirrorlisthost: mirrors.fedoraproject.org
      gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
      gpgcheck: True
      enable: True
    foreman:
      version: latest
      base:
        mirrorurl:
        mirrorhost: yum.theforeman.org
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-foreman
        gpgcheck: True
        enabled: True
        source: False
      plugins:
        mirrorurl:
        mirrorhost: yum.theforeman.org
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-foreman
        gpgcheck: True
        enabled: True
        source: False
    puppetlabs:
      products:
        mirrorurl:
        mirrorhost: yum.puppetlabs.com
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
        gpgcheck: True
        enabled: True
        source: False
      deps:
        mirrorurl:
        mirrorhost: yum.puppetlabs.com
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
        gpgcheck: True
        enabled: True
        source: False
      devel:
        mirrorurl:
        mirrorhost: yum.puppetlabs.com
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
        gpgcheck: True
        enabled: False
        source: False
    other:
      id: logstash-1.3
      name: logstash repository for 1.3.x packages
      baseurl: http://packages.elasticsearch.org/logstash/1.3/centos
      gpgcheck: 1
      gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
      enable: 1
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
