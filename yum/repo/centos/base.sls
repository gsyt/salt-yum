{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'mirrorhost': salt['pillar.get']('yum:repo:centos:base:mirrorhost', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:base:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:base:gpgkey', ''),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:base:gpgcheck', True),
  } %}

  {% set repos = {
    'base': salt['pillar.get']('yum:repo:centos:base', True),
    'updates': salt['pillar.get']('yum:repo:centos:updates', True),
    'extras': salt['pillar.get']('yum:repo:centos:extras', True),
    'centosplus': salt['pillar.get']('yum:repo:centos:centosplus', False),
    'contrib': salt['pillar.get']('yum:repo:centos:contrib', False),
  } %}

  {% if repos %}
    {% if config.mirrorhost or config.mirrorlisthost %}
yum.repo.centos.base:
  require:
      {% for repo in repos %}
    - pkgrepo: yum.repo.centos.base.{{ repo }}
      {% endfor %}

      {% for repo in repos %}
yum.repo.centos.base.{{ repo }}:
  pkgrepo.managed:
    - name: {{ repo }}
        {% if config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/{{ repo }}/$basearch/
        {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo={{ repo }}=
        {% endif %}
        {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
        {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if repos[repo] else 0 }}
      {% endfor %}
    {% endif %}
  {% endif %}
{% endif %}
