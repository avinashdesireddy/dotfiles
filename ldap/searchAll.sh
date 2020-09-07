#!/bin/sh

source ../common.properties

if [ $# -ge 1 ]; then
    LDAP_SEARCH_BASE=$1
    LDAP_SEARCH_STRING=$2
fi

LDAP_CONF=`mktemp /tmp/cm_ldap.XXXXXXXX`
echo "TLS_REQCERT     never" >> $LDAP_CONF
echo "sasl_secprops   minssf=0,maxssf=0" >> $LDAP_CONF

export LDAPCONF=$LDAP_CONF

if [ "${LDAP_SEARCH_STRING}" == "" ]; then
    LDAP_SEARCH_STRING="(objectclass=*)"
fi

ldapsearch -Z -x -D "${LDAP_BIND_USER}" -b "${LDAP_SEARCH_BASE}" -H ${LDAP_HOST_URI} "${LDAP_SEARCH_STRING}" -v -w ${LDAP_BIND_PASS}
