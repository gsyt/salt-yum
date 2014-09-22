include:
  - yum.repo.centos
  - yum.repo.epel
  - yum.repo.other

yum.repo:
  require:
    - sls: yum.repo.centos
    - sls: yum.repo.epel
    - sls: yum.repo.other
