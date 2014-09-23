salt-yum
=========

Salt formula to set up and configure [yum](https://fedoraproject.org/wiki/yum) repositories and mirrors

Parameters
------------
Please refer to example.pillar.sls for a list of available pillar configuration options

Usage
-----
- Apply state 'yum.repo.centos' to configure centos repositories on target minions
- Apply state 'yum.repo.epel' to configure epel repositories on target minions
- Apply state 'yum.repo.foreman' to configure theforeman repositories on target minions
- Apply state 'yum.repo.puppetlabs' to configure puppetlabs repositories on target minions
- Apply state 'yum.repo.other' to configure arbitrary centos repositories on target minions
- Apply state 'yum.mirrors' to configure arbitrary rsync mirrors on target minions

Compatibility
-------------
CentOS 6.x
