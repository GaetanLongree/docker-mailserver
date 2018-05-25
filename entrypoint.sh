#!/bin/bash

if [ -z "$(ls -A /tmp/docker-mailserver)" ]; then
	cp -R /tmp/config/* /tmp/docker-mailserver
fi

# edit the configuration files
cat >> /tmp/docker-mailserver/dovecot.cf << EOF
ssl = no
disable_plaintext_auth = no
EOF

#!/bin/bash
IP_ADDS=$(ip address | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*\/([0-9]*){2}).*/\2/p')
IP_ARRAY=( $IP_ADDS )
IP_LIST="127.0.0.0/8 [::1]/128 [fe80::]/64"

for i in "${IP_ARRAY[@]}"
do
    #replace each /24 with /32
    IP_LIST="$IP_LIST $(echo $i | sed -e 's/\/[0-9][0-9]$/\/32/')"

    MASK=$(echo $i | awk -F "\/" '{print $2}')
    #calculate the subnet with its mask
    if [ "$MASK" == "24" ]; then
        IFS=. read -r io1 io2 io3 io4 <<< $(echo $i | sed 's/\/[0-9][0-9]$//')
        IP_LIST="$IP_LIST $io1.$io2.$io3.0/24"
    elif [ "$MASK" == "16" ]; then
        IFS=. read -r io1 io2 io3 io4 <<< $(echo $i | sed 's/\/[0-9][0-9]$//')
        IP_LIST="$IP_LIST $io1.$io2.0.0/16"
    elif [ "$MASK" == "8" ]; then
        IFS=. read -r io1 io2 io3 io4 <<< $(echo $i | sed 's/\/[0-9][0-9]$//')
        IP_LIST="$IP_LIST $io1.0.0.0/8"
    fi
done

#echo $IP_LIST

#if [ -s /tmp/docker-mailserver/postfix-main.cf ]; then
cat > /tmp/docker-mailserver/postfix-main.cf << EOF
mynetworks = $IP_LIST
alias_maps = ldap:/etc/postfix/ldap-users.cf
alias_database = ldap:/etc/postfix/ldap-users.cf
smtpd_helo_restrictions = permit
smtpd_recipient_restrictions = permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination, check_policy_service unix:private/policyd-spf, reject_unauth_pipelining, reject_unknown_recipient_domain, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net
smtpd_milters =
non_smtpd_milters =
EOF
#fi

chmod -R 777 /var/mail

exec "$@"
