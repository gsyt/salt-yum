{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'mirrorurl': salt['pillar.get']('yum:repo:centos:centosplus:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:centos:centosplus:mirrorhost', ''),
    'mirrorlisturl': salt['pillar.get']('yum:repo:centos:centosplus:mirrorlisturl', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:centosplus:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:centosplus:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:centosplus:gpgcheck', True),
    'enable': salt['pillar.get']('yum:repo:centos:centosplus:enable', False),
  } %}

  {% if config.mirrorhost or config.mirrorlisthost %}
yum.repo.centos.centosplus:
  pkgrepo.managed:
    - name: centosplus
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorlisturl %}
    - mirrorlist: {{ config.mirrorlisturl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/centosplus/$basearch/
    {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo=centosplus
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enable else 0 }}
  {% endif %}
{% endif %}
