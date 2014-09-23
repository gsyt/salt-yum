{% if grains['os'] == 'CentOS' %}

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'mirrorurl': salt['pillar.get']('yum:repo:puppetlabs:products:mirrorurl', ''),
    'mirrorhost': salt['pillar.get']('yum:repo:puppetlabs:products:mirrorhost', 'yum.puppetlabs.com'),
    'gpgkey': salt['pillar.get']('yum:repo:puppetlabs:products:gpgkey', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs'),
    'gpgcheck': salt['pillar.get']('yum:repo:puppetlabs:products:gpgcheck', True),
    'enabled': salt['pillar.get']('yum:repo:puppetlabs:products:enable', True),
    'source': salt['pillar.get']('yum:repo:puppetlabs:products:source', False),
  } %}

  {% if config.mirrorurl or config.mirrorhost %}
yum.repo.puppetlabs.products:
  require:
    - pkgrepo: yum.repo.puppetlabs.products.source
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.puppetlabs.cmd
    - name: puppetlabs-products
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/el/{{ osrelease }}/products/$basearch
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.enabled else 0 }}
  {% endif %}

yum.repo.puppetlabs.products.source:
  pkgrepo.managed:
    - require:
      - cmd: yum.repo.puppetlabs.cmd
    - name: puppetlabs-products-source
    {% if config.mirrorurl %}
    - baseurl: {{ config.mirrorurl }}
    {% elif config.mirrorhost %}
    - baseurl: http://{{ config.mirrorhost }}/el/{{ osrelease }}/products/SRPMS
    {% endif %}
    {% if config.gpgkey %}
    - gpgkey: {{ config.gpgkey }}
    {% endif %}
    - gpgcheck: {{ 1 if config.gpgcheck else 0 }}
    - enabled: {{ 1 if config.source else 0 }}
{% endif %}
