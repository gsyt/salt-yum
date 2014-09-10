{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'mirrorhost' = salt['pillar.get']('yum:repo:centos:mirrorhost', ''),
    'mirrorlisthost' = salt['pillar.get']('yum:repo:centos:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgcheck' = salt['pillar.get']('yum:repo:centos:gpgcheck', False),
  } %}

  {% set repos = {
    'base' = salt['pillar.get']('yum:repo:centos:base', True),
    'updates' = salt['pillar.get']('yum:repo:centos:updates', True),
    'extras' = salt['pillar.get']('yum:repo:centos:extras', False),
    'centosplus' = salt['pillar.get']('yum:repo:centos:centosplus', False),
    'contrib' = salt['pillar.get']('yum:repo:centos:contrib', False),
  } %}

  {% if repos %}
    {% if config.mirrorhost config.mirrorlisthost %}
yum.repo.centos.base:
  require:
      {% for repo in repos %}
    - pkgrepo: yum.repo.centos.base.{{ repo }}
      {% endfor %}

      {% for repo in repos %}
yum.repo.centos.base.{{ repo }}:
  pkgrepo.managed:
    - name: {{ repo }}
    - humanname: CentOS-$releasever - {{ repo }}
        {% if config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/{{ repo }}/$basearch/
        { % else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&{{ repo }}=
        {% endif %}
    - gpgckeck: {{ '1' if config.gpgcheck else '0' }}
    - disabled: {{ False if repos[repo] else True }}
      {% endfor %}
    {% endif %}
  {% endif %}
{% endif %}
