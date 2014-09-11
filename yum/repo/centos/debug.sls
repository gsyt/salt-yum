{% if grains['os'] == 'CentOS' %}
  {% if grains['osrelease'].startswith('5') %}
    {% osrelease = 5 %}
  {% elif grains['osrelease'].startswith('6') %}
    {% osrelease = 6 %}
  {% endif %}  

  {% set config = {
    'mirrorhost': salt['pillar.get']('yum:repo:centos:debug:mirrorhost', 'debuginfo.centos.org'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:debug:gpgcheck', True),
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
    - name: {{ repo }}
    - baseurl: http://{{ config.mirrorhost }}/{{ osrelease }}/$basearch/
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if repos[repo] else 0 }}
    {% endfor %}
  {% endif %}
{% endif %}
