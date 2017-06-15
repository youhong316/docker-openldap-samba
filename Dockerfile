FROM dinkel/openldap:latest
MAINTAINER youhong316@gmail.com

# install additional packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        samba wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# remove samba's init service (just in case)
RUN update-rc.d samba remove

# integrate samba schema in slapd
RUN test -d /etc/ldap.dist/schema || ( gunzip /usr/share/doc/samba/examples/LDAP/samba.schema.gz \
    && cp /usr/share/doc/samba/examples/LDAP/samba.schema /etc/ldap/schema/ )
RUN test -d /etc/ldap.dist/schema || ( gunzip /usr/share/doc/samba/examples/LDAP/samba.ldif.gz \
    && cp /usr/share/doc/samba/examples/LDAP/samba.ldif /etc/ldap/schema/ )
RUN echo "include         /etc/ldap/schema/samba.schema" >> /usr/share/slapd/slapd.conf \ 
    && echo "include: file:///etc/ldap/schema/samba.ldif" >> /usr/share/slapd/slapd.init.ldif
