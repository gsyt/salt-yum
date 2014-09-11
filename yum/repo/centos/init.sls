include:
  - yum.repo.centos.base
  - yum.repo.centos.debug

yum.repo.centos:
  require:
    - sls: yum.repo.centos.base
    - sls: yum.repo.centos.debug
