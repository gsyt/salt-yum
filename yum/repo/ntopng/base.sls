{% if grains['os'] == 'CentOS' and grains['roles'] == 'ntopng' %}

  {% if grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'version': salt['pillar.get']('yum:repo:ntopng:version', 'latest'),
    'mirrorurl': salt['pillar.get']('yum:repo:ntopng:base:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:ntopng:base:mirrorhost', 'www.nmon.net'),
    'gpgkey': salt['pillar.get']('yum:repo:ntopng:base:gpgkey', 'http://www.nmon.net/centos-stable/RPM-GPG-KEY-deri'),
    'gpgcheck': salt['pillar.get']('yum:repo:ntopng:base:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:ntopng:base:enable', True),
  } %}

yum.repo.ntopng.base:
    pkgrepo.managed:
    - require:
      - cmd: yum.repo.ntopng.cmd
    - name: ntopng
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos-stable/{{ osrelease }}/$basearch
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enabled else 0 }}
{% endif %}
