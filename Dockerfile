FROM centos:6.9
ARG container_name
ARG bind_mount_dest
# install system packages
RUN yum install -y sudo yum-plugin-ovl policycoreutils selinux-policy-targeted ; \
yum clean all 
# install EPEL repository for packages bahmni depends on
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
# install packages bahmni depends on
RUN yum install -y python-pip ; \
pip install --upgrade pip ; \
yum install -y git openssh-server openssh-clients tar wget ; \
yum clean all
# install bahmni installer
RUN yum install -y https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.90-308.noarch.rpm
# add inventory file (for ansible)
ADD local /etc/bahmni-installer/local
# set initial bahmni configs
RUN echo -e "selinux_state: disabled\ntimezone: Africa/Maseru\nimplementation_name: default\ndocker: yes " > /etc/bahmni-installer/setup.yml
# install bahmni
RUN bahmni -ilocal install
#---------------------------------------
# edit below layers for development and what not
ARG bind_mount_dest
ARG mighty
ADD db_script.sh /tmp/db_script.sh
RUN chmod a+x /tmp/db_script.sh
ENTRYPOINT sh /tmp/db_script.sh ; bahmni -ilocal start ; /bin/bash
