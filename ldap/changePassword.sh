#!/bin/sh

source ../common.properties

function changePassAsAdmin {
    USER=$1
    echo "Changing LDAP password for ${USER}"

    echo -n "New Password: "
    read -s NEWPASS1

    echo ""
    echo -n "Re-type New Password: "
    read -s NEWPASS2

    if [ "${NEWPASS1}" != "${NEWPASS2}" ]; then
        echo ""
        echo "Passwords do not match"
        exit -1
    fi

    echo ""
    ldappasswd -H ${LDAP_HOST_URI} -x -D "${LDAP_BIND_USER}" -w ${LDAP_BIND_PASS} -s ${NEWPASS1} "uid=${USER},${LDAP_USER_BASE}"

    if [ $? -eq 0 ]; then
        echo ""
        echo "Password changed!"
    fi
}

function changePassAsUser {
    USER=$1
    echo "Changing LDAP password for ${USER}"

    echo -n "Old Password: "
    read -s OLDPASS

    echo ""
    echo -n "New Password: "
    read -s NEWPASS1

    echo ""
    echo -n "Re-type New Password: "
    read -s NEWPASS2

    if [ "${NEWPASS1}" != "${NEWPASS2}" ]; then
        echo ""
        echo "Passwords do not match"
        exit -1
    fi

    echo ""
    ldappasswd -H ${LDAP_HOST_URI} -x -D "uid=${USER},${LDAP_USER_BASE}" -w ${OLDPASS} -a ${OLDPASS} -s ${NEWPASS1}

    if [ $? -eq 0 ]; then
        echo ""
        echo "Password changed!"
    fi
}

if [ "$#" -eq 1 ]; then
    changePassAsAdmin $1
else
    changePassAsUser  $(whoami)
fi

