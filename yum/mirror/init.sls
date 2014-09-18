{% from "yum/map.jinja" import yum with context %}

{% set config = {
  'require': salt['pillar.get']('yum:mirror:require', []),
  'mirrors': salt['pillar.get']('yum:mirror:mirrors', []),
  'user': salt['pillar.get']('yum:mirror:user', 'root'),
  'group': salt['pillar.get']('yum:mirror:group', ''),
} %}

{% if config.mirrors %}
yum.mirror:
  require:
  {% if config.mirrors %}
    {% for mirror in config.mirrors %}
      {% set mirrorconfig = {
        'rsyncurl': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':rsyncurl', ''),
        'path': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':path', ''),
      } %}
      {% if mirrorconfig.rsyncurl and mirrorconfig.path %}
    - sls: yum.mirror.{{ mirror }}
      {% endif %}
    {% endfor %}
  {% endif %}
  {% if config.require %}
    {% for require in config.require %}
    - sls: {{ require }}
    {% endfor %}
  {% endif %}

  {% for mirror in config.mirrors %}
    {% set mirrorconfig = {
        'rsyncurl': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':rsyncurl', ''),
        'rsyncopts': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':rsyncopts', '-avSHP --numeric-ids --delete --delete-delay --delay-updates'),
        'path': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':path', ''),
        'enable': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':enable', True),
        'minute': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':minute', '0'),
        'hour': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':hour', '0'),
        'dayweek': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':dayweek', '*'),
        'month': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':month', '*'),
        'daymonth': salt['pillar.get']('yum:mirror:mirrors:' ~ mirror ~ ':daymonth', '*'),
      } %}
    {% if mirrorconfig.rsyncurl and mirrorconfig.path %}
      {% set updatefile = mirrorconfig.path ~ '/update' %}
      {% set excludefile = mirrorconfig.path ~ '/exclude' %}
yum.mirror.{{ mirror }}:
  require:
    - sls: yum.mirror.{{ mirror }}.cron

yum.mirror.{{ mirror }}.dir:
  file.directory:
    - name: {{ mirrorconfig.path }}
    - user: {{ config.user }}
    - group: {{ config.group }}
    - recurse: 
      - user
      - group
    - makedirs: True

yum.mirror.{{ mirror }}.cron:
  require:
    - file: yum.mirror.{{ mirror }}.update
  cron.{{ 'present' if mirrorconfig.enable else 'absent' }}:
    - name: {{ yum.rsync }} {{ mirrorconfig.rsyncopts }} {{ mirrorconfig.rsyncurl }} {{ mirrorconfig.path }}
    - user: {{ config.user }}
    - minute: '{{ mirrorconfig.minute }}'
    - hour: '{{ mirrorconfig.hour }}'
    - daymonth: '{{ mirrorconfig.daymonth }}'
    - month: '{{ mirrorconfig.month }}'
    - dayweek: '{{ mirrorconfig.dayweek }}'
    - identifier: {{ mirror }}
    {% endif %}
  {% endfor %}
{% endif %}
