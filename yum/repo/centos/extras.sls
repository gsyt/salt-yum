{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'manage': salt['pillar.get']('yum:repo:centos:extras:manage', False),
    'mirrorurl': salt['pillar.get']('yum:repo:centos:extras:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:centos:extras:mirrorhost', ''),
    'mirrorlisturl': salt['pillar.get']('yum:repo:centos:extras:mirrorlisturl', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:extras:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:extras:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:extras:gpgcheck', True),
    'enable': salt['pillar.get']('yum:repo:centos:extras:enable', True),
  } %}

  {% if config.manage and ( config.mirrorhost or config.mirrorlisthost ) %}
yum.repo.centos.extras:
  pkgrepo.managed:
    - name: extras
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorlisturl %}
    - mirrorlist: {{ config.mirrorlisturl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/extras/$basearch/
    {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo=extras
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enable else 0 }}
  {% endif %}
{% endif %}
