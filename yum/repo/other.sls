{% from "yum/map.jinja" import yum with context %}

{% set config = {
  'repos': salt['pillar.get']('yum:repo:other', []),
} %}

{% if config.repos %}
yum.repo.other:
  require:
  {% for repo in config.repos %}
    {% set repoconfig = {
      'id': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':id', ''),
      'name': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':name', ''),
      'baseurl': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':baseurl', ''),
      'repolist': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':repolist', ''),
      'gpgcheck': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':gpgcheck', ''),
      'gpgkey': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':gpgkey', ''),
      'enable': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':enable', ''),
    } %}
    {% if repoconfig.mirrorlist or repoconfig.baseurl %}
    - sls: yum.repo.other.{{ repo }}
    {% endif %}
  {% endfor %}

  {% for repo in config.repos %}
    {% set repoconfig = {
      'id': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':id', ''),
      'name': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':name', ''),
      'baseurl': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':baseurl', ''),
      'repolist': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':repolist', ''),
      'gpgcheck': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':gpgcheck', ''),
      'gpgkey': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':gpgkey', ''),
      'enable': salt['pillar.get']('yum:repo:other:' ~ repo ~ ':enable', ''),
    } %}
    {% if repoconfig.mirrorlist or repoconfig.baseurl %}
yum.repo.other.{{ repo }}:
  pkgrepo.managed:
    - name: {{ repoconfig.id }}
    - humanname: {{ repoconfig.name }}
      {% if repoconfig.mirrorlist %}
    - mirrorlist: {{ repoconfig.mirrorlist }}
      {% else %}
    - baseurl: {{ repoconfig.baseurl }}
      {% endif %}
    - gpgcheck: {{ 1 if repoconfig.gpgcheck else 0 }}
    - gpgkey: {{ repoconfig.gpgkey }}
    - enabled: {{ 1 if repoconfig.enable else 0 }}
    {% endif %}
  {% endfor %}
{% endif %}
