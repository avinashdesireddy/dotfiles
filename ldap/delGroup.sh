#!/bin/sh

source ../common.properties

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 group"
    exit -1
fi 

GROUP=$1

echo -n "Delete group ${GROUP} from LDAP? [yes|no] "
read RESPONSE

if [ "${RESPONSE}" == "yes" ]; then
    ldapdelete -D "${LDAP_BIND_USER}" "uid=${GROUP},${LDAP_GROUP_BASE}" -w ${LDAP_BIND_PASS}
else
    echo ""
    echo "Aborted operation!"
fi
