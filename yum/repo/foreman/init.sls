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
  } %}

  {% set baseconfig = {
    'mirrorurl': salt['pillar.get']('yum:repo:foreman:base:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:foreman:base:mirrorhost', 'yum.theforeman.org'),
    'gpgkey': salt['pillar.get']('yum:repo:foreman:base:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-foreman'),
    'gpgcheck': salt['pillar.get']('yum:repo:foreman:base:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:foreman:base:enable', True),
    'source': salt['pillar.get']('yum:repo:foreman:base:source', False),
  } %}

  {% set pluginconfig = {
    'mirrorurl': salt['pillar.get']('yum:repo:foreman:plugins:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:foreman:plugins:mirrorhost', 'yum.theforeman.org'),
    'gpgkey': salt['pillar.get']('yum:repo:foreman:plugins:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-foreman'),
    'gpgcheck': salt['pillar.get']('yum:repo:foreman:plugins:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:foreman:plugins:enable', True),
    'source': salt['pillar.get']('yum:repo:foreman:plugins:source', False),
  } %}

yum.repo.foreman:
  require:
    - sls: yum.repo.foreman.pkg
    - sls: yum.repo.foreman.base
    - sls: yum.repo.foreman.plugins

yum.repo.foreman.pkg:
  cmd.run:
    - name: yum install -y http://yum.theforeman.org/releases/{{ config.version }}/el{{ osrelease }}/{{ grains['osarch'] }}/foreman-release.rpm
    - unless: test -e /etc/yum.repos.d/foreman.repo

  {% if baseconfig.mirrorurl or baseconfig.mirrorhost %}
yum.repo.foreman.base:
  require:
    - pkgrepo: yum.repo.foreman.base.source
  pkgrepo.managed:
    - name: foreman
    {% if baseconfig.mirrorurl %}
    - baseurl: {{ baseconfig.mirrorurl }}
    {% elif baseconfig.mirrorhost %}
    - baseurl: "http://{{ baseconfig.mirrorhost }}/releases/{{ config.version }}/el{{ osrelease }}/$basearch"
    {% endif %}
    {% if baseconfig.gpgkey %}
    - gpgkey: {{ baseconfig.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if baseconfig.gpgcheck else 0 }}
    - enabled: {{ 1 if baseconfig.enabled else 0 }}
  {% endif %}

yum.repo.foreman.base.source:
  pkgrepo.managed:
    - name: foreman-source
    {% if baseconfig.mirrorurl %}
    - baseurl: {{ baseconfig.mirrorurl }}
    {% elif baseconfig.mirrorhost %}
    - baseurl: "http://{{ baseconfig.mirrorhost }}/releases/{{ config.version }}/el{{ osrelease }}/source"
    {% endif %}
    {% if baseconfig.gpgkey %}
    - gpgkey: {{ baseconfig.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if baseconfig.gpgcheck else 0 }}
    - enabled: {{ 1 if baseconfig.source else 0 }}

  {% if pluginconfig.mirrorurl or pluginconfig.mirrorhost %}
yum.repo.foreman.plugins:
  require:
    - pkgrepo: yum.repo.foreman.plugins.source
  pkgrepo.managed:
    - name: foreman-plugins
    {% if pluginconfig.mirrorurl %}
    - baseurl: {{ pluginconfig.mirrorurl }}
    {% elif pluginconfig.mirrorhost %}
    - baseurl: http://{{ pluginconfig.mirrorhost }}/plugins/{{ config.version }}/el{{ osrelease }}/$basearch
    {% endif %}
    {% if pluginconfig.gpgkey %}
    - gpgkey: {{ pluginconfig.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if pluginconfig.gpgcheck else 0 }}
    - enabled: {{ 1 if pluginconfig.enabled else 0 }}
  {% endif %}

yum.repo.foreman.plugins.source:
  pkgrepo.managed:
    - name: foreman-plugins-source
    {% if pluginconfig.mirrorurl %}
    - baseurl: {{ pluginconfig.mirrorurl }}
    {% elif pluginconfig.mirrorhost %}
    - baseurl: http://{{ pluginconfig.mirrorhost }}/plugins/{{ config.version }}/el{{ osrelease }}/source
    {% endif %}
    {% if pluginconfig.gpgkey %}
    - gpgkey: {{ pluginconfig.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if pluginconfig.gpgcheck else 0 }}
    - enabled: {{ 1 if pluginconfig.source else 0 }}
{% endif %}
