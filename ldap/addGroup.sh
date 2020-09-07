#!/bin/sh

source ../common.properties

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 name \"description\" gid"
    exit -1
fi 

GROUP=$1
DESCRIPTION=$2
GRPID=$3
LDIF=$(mktemp /tmp/XXXXX.ldif)

cat > ${LDIF} << EOF
dn: cn=${GROUP},${LDAP_GROUP_BASE}
cn: ${GROUP}
description: ${DESCRIPTION}
gidNumber: ${GRPID}
objectClass: posixGroup
EOF

cat ${LDIF}
echo -n "Add this group to LDAP? [yes|no] "
read RESPONSE

if [ "${RESPONSE}" == "yes" ]; then
    ldapadd -D "${LDAP_BIND_USER}" -f ${LDIF} -w ${LDAP_BIND_PASS}
else
    echo ""
    echo "Aborted operation!"
fi
