# docker-mailserver
Simplistic version of the [tvial/docker-mailserver](https://hub.docker.com/r/tvial/docker-mailserver/).

Works perfectly with [roundcube](https://hub.docker.com/r/roundcube/roundcubemail/) and [https://hub.docker.com/r/cajetan19/openldap/](https://hub.docker.com/r/cajetan19/openldap/).

**NOTE:** this container is made for testing and does not implement any security measures (as a matter of fact, authentication with dovecot is allowed in plaintext).

## Sample `docker run`

```
docker run --detach \
-p 25:25 \
-p 143:143 \
-p 587:587 \
-p 993:993 \
--volume /share/mail:/var/mail \
--volume /share/mail-state:/var/mail-state \
--volume /share/config:/tmp/docker-mailserver \
--env DMS_DEBUG=0 \
--env ENABLE_CLAMAV=1 \
--env ONE_DIR=1 \
--env ENABLE_POP3=1 \
--env ENABLE_FAIL2BAN=0 \
--env ENABLE_MANAGESIEVE=0 \
--env OVERRIDE_HOSTNAME=mail.contoso.com \
--env POSTMASTER_ADDRESS=postmaster@contoso.com \
--env POSTSCREEN_ACTION=enforce \
--env SPOOF_PROTECTION=1 \
--env ENABLE_SRS=0 \
--env ENABLE_SPAMASSASSIN=1 \
--env ENABLE_LDAP=1 \
--env LDAP_SERVER_HOST=172.17.0.10 \
--env LDAP_SEARCH_BASE=ou=users,dc=contoso,dc=com \
--env LDAP_BIND_DN=cn=admin,dc=contoso,dc=com \
--env LDAP_BIND_PW=password \
--env ENABLE_POSTGREY=1 \
--env ENABLE_SASLAUTHD=1 \
--env SASLAUTHD_MECHANISMS=ldap \
--env SASLAUTHD_LDAP_SERVER=172.17.0.10 \
--env SASLAUTHD_LDAP_SSL=0 \
--env SASLAUTHD_LDAP_BIND_DN=cn=admin,dc=contoso,dc=com \
--env SASLAUTHD_LDAP_PASSWORD=password \
--env SASLAUTHD_LDAP_SEARCH_BASE=ou=users,dc=contoso,dc=com \
--env SASLAUTHD_LDAP_FILTER="(&(uid=%U)(objectClass=posixAccount))" \
--env DOVECOT_PASS_FILTER="(&(objectClass=posixAccount)(mail=%u))" \
--env DOVECOT_USER_FILTER="(&(objectClass=posixAccount)(mail=%u))" \
--env LDAP_QUERY_FILTER_USER="(&(mail=%s)(mailEnabled=TRUE))" \
--env LDAP_QUERY_FILTER_GROUP="(&(mail=%s)(mailEnabled=TRUE))" \
--env LDAP_QUERY_FILTER_ALIAS="(&(mail=%s)(mailEnabled=TRUE))" \
--network mynetwork \
--ip 172.18.0.12 \
--dns 172.18.0.11 \
--hostname mail.contoso.com \
--name mail \
cajetan19/mailserver
```
