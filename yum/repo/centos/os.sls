{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'mirrorurl': salt['pillar.get']('yum:repo:centos:os:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:centos:os:mirrorhost', ''),
    'mirrorlisturl': salt['pillar.get']('yum:repo:centos:os:mirrorlisturl', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:os:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:os:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:os:gpgcheck', True),
    'enable': salt['pillar.get']('yum:repo:centos:os:enable', True),
  } %}

  {% if config.mirrorhost or config.mirrorlisthost %}
yum.repo.centos.os:
  pkgrepo.managed:
    - name: os
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhosturl %}
    - mirrorlist: {{ config.mirrorlisturl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/os/$basearch/
    {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo=os
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enable else 0 }}
  {% endif %}
{% endif %}
