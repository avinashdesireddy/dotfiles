#!/bin/sh

source ../common.properties

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 username group"
    exit -1
fi

USER=$1
GROUP=$2
LDIF=$(mktemp /tmp/XXXXX.ldif)

cat > ${LDIF} << EOF
dn: cn=${GROUP},${LDAP_GROUP_BASE}
changetype: modify
delete: memberUid
memberUid: ${USER}
EOF

echo -n "Delete user ${USER} from ${GROUP}? [yes|no] "
read RESPONSE

if [ "${RESPONSE}" == "yes" ]; then
    ldapmodify -D "${LDAP_BIND_USER}" -f ${LDIF} -w ${LDAP_BIND_PASS}
else
    echo ""
    echo "Aborted operation!"
fi
