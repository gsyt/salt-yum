{% if grains['os'] == 'CentOS' %}
  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
    {% set epelrelease = '5-4' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
    {% set epelrelease = '6-8' %}
  {% endif %}  

  {% set config = {
    'mirrorhost': salt['pillar.get']('yum:repo:epel:mirrorhost', ''),
    'mirrorlisthost': salt['pillar.get']('yum:repo:epel:mirrorlisthost', 'mirrors.fedoraproject.org'),
    'gpgkey': salt['pillar.get']('yum:repo:epel:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6'),
    'gpgcheck': salt['pillar.get']('yum:repo:epel:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:epel:enable', True),
  } %}

  {% if config.mirrorhost or config.mirrorlisthost %}
yum.repo.epel:
  cmd.run:
    - name: rpm -Uvh http://download.fedoraproject.org/pub/epel/{{ osrelease }}/{{ grains['osarch'] }}/epel-release-{{ epelrelease }}.noarch.rpm
    - unless: test -e /etc/yum.repos.d/epel.repo
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.epel
    - name: epel
    {% if config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/pub/epel/{{ osrelease }}/$basearch
    {% else %}
    - mirrorlist: https://{{ config.mirrorlisthost }}/metalink?repo=epel-{{ osrelease }}&arch=$basearch
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enabled else 0 }}
  {% endif %}
{% endif %}
