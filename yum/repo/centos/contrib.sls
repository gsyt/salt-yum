{% if grains['os'] == 'CentOS' %}

  {% set config = {
    'manage': salt['pillar.get']('yum:repo:centos:contrib:manage', False),
    'mirrorurl': salt['pillar.get']('yum:repo:centos:contrib:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:centos:contrib:mirrorhost', ''),
    'mirrorlisturl': salt['pillar.get']('yum:repo:centos:contrib:mirrorlisturl', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:centos:contrib:mirrorlisthost', 'mirrorlist.centos.org'),
    'gpgkey': salt['pillar.get']('yum:repo:centos:contrib:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:centos:contrib:gpgcheck', True),
    'enable': salt['pillar.get']('yum:repo:centos:contrib:enable', False),
  } %}

  {% if config.manage and ( config.mirrorhost or config.mirrorlisthost ) %}
yum.repo.centos.contrib:
  pkgrepo.managed:
    - name: contrib
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorlisturl %}
    - mirrorlist: {{ config.mirrorlisturl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/centos/$releasever/contrib/$basearch/
    {% else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/?release=$releasever&arch=$basearch&repo=contrib
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enable else 0 }}
  {% endif %}
{% endif %}
