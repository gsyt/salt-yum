{% if grains['os'] == 'CentOS' %}
  {% if grains['osrelease'].startswith('5') %}
    {% osrelease = 5 %}
    {% epelrelease = 5-4 %}
  {% elif grains['osrelease'].startswith('6') %}
    {% osrelease = 6 %}
    {% epelrelease = 6-8 %}
  {% endif %}  

  {% set config = {
    'mirrorhost' = salt['pillar.get']('yum:repo:epel:mirrorhost', ''),
    'mirrorlisthost' = salt['pillar.get']('yum:repo:epel:mirrorlisthost', 'mirrors.fedoraproject.org'),
    'gpgcheck' = salt['pillar.get']('yum:repo:epel:gpgcheck', False),
    'enabled' = salt['pillar.get']('yum:repo:epel:enabled', True),
  } %}

  {% if config.mirrorhost config.mirrorlisthost %}
yum.repo.centos.epel:
  cmd.run:
    - name: rpm -Uvh http://download.fedoraproject.org/pub/epel/{{ release }}/{{ grains['osarch'] }}/epel-release-{{ epelrelease }}.noarch.rpm
    - unless: test -e /etc/yum.repos.d/epel.repo
  pkgrepo.managed:
    require:
      - cmd: yum.repo.centos.epel
    - name: epel
    - humanname: Extra Packages for Enterprise Linux {{ osrelease }} - $basearch
    {% if config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/pub/epel/{{ osrelease }}/$basearch
    { % else %}
    - mirrorlist: http://{{ config.mirrorlisthost }}/metalink?repo={{ repo }}-{{ osrelease }}&arch=$basearch
    {% endif %}
    - gpgckeck: {{ '1' if config.gpgcheck else '0' }}
    - disabled: {{ False if config.enabled else True }}
  {% endif %}
{% endif %}
