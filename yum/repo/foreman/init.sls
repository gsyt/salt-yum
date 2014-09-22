{% if grains['os'] == 'CentOS' %}

include:
  - yum.repo.foreman.base
  - yum.repo.foreman.plugins

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'version': salt['pillar.get']('yum:repo:foreman:version', 'latest'),
  } %}

yum.repo.foreman:
  require:
    - sls: yum.repo.foreman.base
    - sls: yum.repo.foreman.plugins

yum.repo.foreman.cmd:
  cmd.run:
    - name: rpm -Uvh http://yum.theforeman.org/releases/{{ config.version }}/el{{ osrelease }}/$basearch/foreman-release.rpm
    - unless: test -e /etc/yum.repos.d/foreman.repo
