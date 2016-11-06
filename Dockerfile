FROM dinkel/openldap:latest
MAINTAINER michelkaeser

# additional packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        samba wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# remove samba's init service
RUN update-rc.d samba remove

# samba schema
RUN gunzip /usr/share/doc/samba/examples/LDAP/samba.schema.gz
RUN cp /usr/share/doc/samba/examples/LDAP/samba.schema /etc/ldap/schema/
RUN gunzip /usr/share/doc/samba/examples/LDAP/samba.ldif.gz
RUN cp /usr/share/doc/samba/examples/LDAP/samba.ldif /etc/ldap/schema/
RUN slapadd -n0 -F /etc/ldap/slapd.d -l "/etc/ldap/schema/samba.ldif"

# sshPublicKey schema
RUN wget -O /etc/ldap/schema/openssh-lpk-openldap.schema \
    https://raw.githubusercontent.com/AndriiGrytsenko/openssh-ldap-publickey/master/misc/openssh-lpk-openldap.schema
RUN wget -O /etc/ldap/schema/openssh-lpk-openldap.ldif \
    https://raw.githubusercontent.com/AndriiGrytsenko/openssh-ldap-publickey/master/misc/openssh-lpk-openldap.ldif
RUN slapadd -n0 -F /etc/ldap/slapd.d -l "/etc/ldap/schema/openssh-lpk-openldap.ldif"
