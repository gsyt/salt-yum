{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'mirrorhost': salt['pillar.get']('yum:repo:centos:debug:mirrorhost', 'debuginfo.centos.org'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:debug:gpgcheck', False),
  } %}

  {% set repos = {
    'debug': salt['pillar.get']('yum:repo:centos:base', True),
  } %}

  {% if repos %}
yum.repo.centos.debug:
  require:
    {% for repo in repos %}
    - pkgrepo: yum.repo.centos.base.{{ repo }}
    {% endfor %}

    {% for repo in repos %}
yum.repo.centos.base.{{ repo }}:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - {{ repo }}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/$basearch/
    - gpgckeck: {{ '1' if config.gpgcheck else '0' }}
    - disabled: {{ False if repos[repo] else True }}
    {% endfor %}
  {% endif %}
{% endif %}
