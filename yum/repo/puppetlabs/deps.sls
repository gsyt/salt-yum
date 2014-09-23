{% if grains['os'] == 'CentOS' %}

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'mirrorurl': salt['pillar.get']('yum:repo:puppetlabs:deps:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:puppetlabs:deps:mirrorhost', 'yum.puppetlabs.com'),
    'gpgkey': salt['pillar.get']('yum:repo:puppetlabs:deps:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs'),
    'gpgcheck': salt['pillar.get']('yum:repo:puppetlabs:deps:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:puppetlabs:deps:enable', True),
    'source': salt['pillar.get']('yum:repo:puppetlabs:deps:source', False),
  } %}

  {% if config.mirrorurl or config.mirrorhost %}
yum.repo.puppetlabs.deps:
  require:
    - pkgrepo: yum.repo.puppetlabs.deps.source
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.puppetlabs.cmd
    - name: puppetlabs-deps
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/el/{{ osrelease }}/dependencies/$basearch
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enabled else 0 }}
  {% endif %}

yum.repo.puppetlabs.deps.source:
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.puppetlabs.cmd
    - name: puppetlabs-deps-source
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/el/{{ osrelease }}/dependencies/SRPMS
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.source else 0 }}
{% endif %}
