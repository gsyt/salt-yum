{% if grains['os'] == 'CentOS' %}

include:
  - yum.repo.puppetlabs.products
  - yum.repo.puppetlabs.deps
  - yum.repo.puppetlabs.devel

  {% if grains['osrelease'].startswith('5') %}
    {% set osrelease = '5' %}
  {% elif grains['osrelease'].startswith('6') %}
    {% set osrelease = '6' %}
  {% elif grains['osrelease'].startswith('7') %}
    {% set osrelease = '7' %}
  {% endif %}  

  {% set config = {
    'version': salt['pillar.get']('yum:repo:foreman:version', 'latest'),
  } %}

yum.repo.puppetlabs:
  require:
    - sls: yum.repo.puppetlabs.products
    - sls: yum.repo.puppetlabs.deps
    - sls: yum.repo.puppetlabs.devel

yum.repo.puppetlabs.cmd:
  cmd.run:
    - name: rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-{{ osrelease }}.noarch.rpm
    - unless: test -e /etc/yum.repos.d/puppetlabs.repo
{% endif %}
