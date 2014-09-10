salt-yum
=========

Salt formula to set up and configure [yum](https://fedoraproject.org/wiki/yum) repositories and mirrors

Parameters
------------
Please refer to example.pillar.sls for a list of available pillar configuration options

Usage
-----
- Apply state 'yum.client' to configure repositories on target minions
- Apply state 'yum.mirror' to configure yum mirrors on target minions

Compatibility
-------------
CentOS 6.x
