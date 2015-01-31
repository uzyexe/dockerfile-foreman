FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install -qy wget vim git dnsutils postgresql sqlite3 && \
    echo "deb http://deb.theforeman.org/ wheezy 1.7" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins 1.7" >> /etc/apt/sources.list.d/foreman.list && \
    wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    apt-get update -qq && \
    apt-get install -qy foreman-installer foreman foreman-proxy foreman-sqlite3

ENV FOREOPTS --foreman-admin-password=changeme \
             --foreman-environment=development \
             --foreman-db-type=sqlite \
             --foreman-db-adapter=sqlite3 \
             --foreman-db-database=db/production.sqlite3 \
             --enable-foreman-compute-ec2 \
             --enable-foreman-compute-gce \
             --enable-foreman-compute-ovirt \
             --enable-foreman-compute-vmware \
             --enable-foreman-compute-libvirt \
             --enable-foreman-compute-openstack \
             --enable-foreman-compute-rackspace \
             --enable-foreman-proxy \
             --enable-puppet \
             --puppet-listen=true \
             --puppet-show-diff=true \
             --puppet-server-envs-dir=/etc/puppet/environments

CMD ( test ! -f /etc/foreman/.first_run_completed && \
        ( echo "FIRST-RUN: Please wait while Foreman is installed and configured..."; \
        /usr/sbin/foreman-installer $FOREOPTS; \
        sed -i -e "s/START=no/START=yes/g" /etc/default/foreman; \
        touch /etc/foreman/.first_run_completed \
        ) \
    ); \
    /etc/init.d/foreman restart; \
    /etc/init.d/foreman-proxy restart; \
    /etc/init.d/apache2 restart; \
    /etc/init.d/tftpd-hpa restart; \
    /etc/init.d/puppet restart; \
    tail -f /var/log/foreman/production.log

EXPOSE 443
EXPOSE 8140
EXPOSE 8443
