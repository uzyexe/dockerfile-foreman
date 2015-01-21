FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
ENV FOREOPTS --foreman-locations-enabled \
        --foreman-environment=development \
        --foreman-db-type=sqlite \
        --foreman-db-adapter=sqlite3 \
        --foreman-db-database=db/production.sqlite3 \
        --foreman-proxy-tftp=true \
        --foreman-proxy-dhcp=false \
        --foreman-proxy-dhcp-range="192.168.1.0/24"

RUN apt-get update -qq && \
    apt-get dist-upgrade -qy && \
    apt-get install -qy wget vim git traceroute dnsutils postgresql sqlite3 isc-dhcp-server && \
    echo "deb http://deb.theforeman.org/ wheezy 1.7" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins 1.7" >> /etc/apt/sources.list.d/foreman.list && \
    wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    apt-get update -qq && \
    apt-get install -qy foreman-installer foreman-sqlite3

EXPOSE 443
EXPOSE 8140
EXPOSE 8443

CMD ( test ! -f /etc/foreman/.first_run_completed && \
        ( echo "FIRST-RUN: Please wait while Foreman is installed and configured..."; \
        /usr/sbin/foreman-installer $FOREOPTS; \
        sed -i -e "s/START=no/START=yes/g" /etc/default/foreman; \
        touch /etc/foreman/.first_run_completed \
        ) \
    ); \
    /etc/init.d/puppet stop; \
    /etc/init.d/apache2 stop; \
    /etc/init.d/foreman stop; \
    /etc/init.d/postgresql stop; \
    /etc/init.d/foreman start; \
    /etc/init.d/apache2 start; \
    /etc/init.d/puppet start; \
    /etc/init.d/postgresql start; \
    tail -f /var/log/foreman/production.log
