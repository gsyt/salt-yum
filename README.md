salt-yum
=========

Salt formula to set up and configure [yum](https://fedoraproject.org/wiki/yum) repositories and mirrors

Parameters
------------
Please refer to pillar.example.sls for a list of available pillar configuration options

Usage
-----
- Apply state 'yum.repo.centos' to configure centos repositories on target minions
- Apply state 'yum.repo.epel' to configure epel repositories on target minions
- Apply state 'yum.repo.foreman' to configure foreman repositories on target minions
- Apply state 'yum.repo.other' to configure arbitrary centos repositories on target minions
- Apply state 'yum.mirrors' to configure arbitrary rsync mirrors on target minions

Compatibility
-------------
CentOS 6.x
