{% if grains['os'] == 'CentOS' and grains['roles'] == 'ntopng' %}

include:
  - yum.repo.ntopng.base

  {% if grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'version': salt['pillar.get']('yum:repo:ntopng:version', 'latest'),
  } %}

yum.repo.ntopng:
  require:
    - sls: yum.repo.ntopng.base

yum.repo.ntopng.cmd:
  cmd.run:
    - name: rpm -Uvh http://www.nmon.net/centos-stable/{{ osrelease }}/$basearch/Packages/nProbe-6.16.140907-4337.x86_64.rpm
    - unless: test -e /etc/yum.repos.d/ntopng.repo
