{% if grains['os'] == 'CentOS' %}

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = 5 %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = 6 %}
  {% endif %}  

  {% set config = {
    'mirrorhost': salt['pillar.get']('yum:repo:centos:debug:mirrorhost', 'debuginfo.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:debug:gpgkey', ''),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:debug:gpgcheck', True),
  } %}

  {% set repos = {
    'debug': salt['pillar.get']('yum:repo:centos:base', False),
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
    - name: {{ repo }}
    - baseurl: http://{{ config.mirrorhost }}/{{ osrelease }}/$basearch/
      {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
      {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if repos[repo] else 0 }}
    {% endfor %}
  {% endif %}
{% endif %}
