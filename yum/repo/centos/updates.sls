{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'manage': salt['pillar.get']('yum:repo:centos:updates:manage', True),
    'mirrorurl': salt['pillar.get']('yum:repo:centos:updates:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:centos:updates:mirrorhost', ''),
    'mirrorlisturl': salt['pillar.get']('yum:repo:centos:updates:mirrorlisturl', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:updates:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:updates:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:updates:gpgcheck', True),
    'enable': salt['pillar.get']('yum:repo:centos:updates:enable', True),
  } %}

  {% if config.manage and ( config.mirrorhost or config.mirrorlisthost ) %}
yum.repo.centos.updates:
  pkgrepo.managed:
    - name: updates
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorlisturl %}
    - mirrorlist: {{ config.mirrorlisturl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/updates/$basearch/
    {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo=updates
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enable else 0 }}
  {% endif %}
{% endif %}
