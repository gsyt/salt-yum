{% if grains['os'] == 'CentOS' %}

include:
  - yum.repo.centos.base
  - yum.repo.centos.updates
  - yum.repo.centos.extras
  - yum.repo.centos.centosplus
  - yum.repo.centos.contrib
  - yum.repo.centos.debug

yum.repo.centos:
  require:
    - sls: yum.repo.centos.base
    - sls: yum.repo.centos.updates
    - sls: yum.repo.centos.extras
    - sls: yum.repo.centos.centosplus
    - sls: yum.repo.centos.contrib
    - sls: yum.repo.centos.debug

{% endif %}
