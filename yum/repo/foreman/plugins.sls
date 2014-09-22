{% if grains['os'] == 'CentOS' %}

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'version': salt['pillar.get']('yum:repo:foreman:version', 'latest'),
    'mirrorurl': salt['pillar.get']('yum:repo:foreman:plugins:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:foreman:plugins:mirrorhost', 'yum.theforeman.org'),
    'gpgkey': salt['pillar.get']('yum:repo:foreman:plugins:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-foreman'),
    'gpgcheck': salt['pillar.get']('yum:repo:foreman:plugins:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:foreman:plugins:enable', True),
    'source': salt['pillar.get']('yum:repo:foreman:plugins:source', False),
  } %}

  {% if config.mirrorurl or config.mirrorhost %}
yum.repo.foreman.plugins:
  require:
    - pkgrepo: yum.repo.foreman.plugins.source
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.foreman.cmd
    - name: foreman-plugins
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/plugins/{{ config.version }}/el{{ osrelease }}/$basearch
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enabled else 0 }}
  {% endif %}

yum.repo.foreman.plugins.source:
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.foreman.cmd
    - name: foreman-plugins-source
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/plugins/{{ config.version }}/el{{ osrelease }}/source
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.source else 0 }}
  {% endif %}
{% endif %}
