#!/bin/sh

source ../common.properties

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 username"
    exit -1
fi 

USER=$1
LDIF=$(mktemp /tmp/XXXXX.ldif)

echo "Delete user ${USER} from LDAP? [yes|no] "
read RESPONSE

if [ "${RESPONSE}" == "yes" ]; then
    ldapdelete -D "${LDAP_BIND_USER}" "uid=${USER},${LDAP_USER_BASE}" -w ${LDAP_BIND_PASS}

    if [ $? -eq 0 ]; then
        cat > ${LDIF} << EOF
dn: cn=users,${LDAP_GROUP_BASE}
changetype: modify
delete: memberUid
memberUid: ${USER}
EOF
        ldapmodify -D "${LDAP_BIND_USER}" -f ${LDIF} -w ${LDAP_BIND_PASS}
    fi
else
    echo ""
    echo "Aborted operation!"
fi
