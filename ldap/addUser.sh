#!/bin/sh

source ../common.properties

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 username \"full name\" "
    exit -1
fi 

USER=$1
NAME=$2
GNAME=$(echo ${NAME} | awk -F' ' {'print $1'})
SNAME=$(echo ${NAME} | awk -F' ' {'print $2'})
INITIALS=$(echo ${GNAME} | cut -c1-1)$(echo ${SNAME} | cut -c1-1)
LDIF=$(mktemp /tmp/XXXXX.ldif)

cat > ${LDIF} << EOF
dn: uid=${USER},${LDAP_USER_BASE}
displayName: ${NAME}
cn: ${NAME}
givenName: ${GNAME}
sn: ${SNAME}
initials: ${INITIALS}
mail: ${USER}@$(hostname -f)
uid: ${USER}
homeDirectory: /home/${USER}
loginShell: /bin/bash
gecos: ${NAME},,,,
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
userPassword: {SSHA}9wUIYxF9xQ1QxC0+owi756u82BZKrNLW
EOF

cat ${LDIF}
echo -n "Add this user to LDAP? [yes|no] "
read ADDRESPONSE

if [ "${ADDRESPONSE}" == "yes" ]; then
    ldapadd -D "${LDAP_BIND_USER}" -f ${LDIF} -w ${LDAP_BIND_PASS}
    if [ $? -eq 0 ]; then
        cat > ${LDIF} << EOF
dn: cn=users,${LDAP_GROUP_BASE}
changetype: modify
add: memberUid
memberUid: ${USER}
EOF
        ldapmodify -D "${LDAP_BIND_USER}" -f ${LDIF} -w ${LDAP_BIND_PASS}
    fi
else
    echo ""
    echo "Aborted operation!"
fi
