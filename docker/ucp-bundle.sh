[ -z "$UCP_URL" ] && read -p "UCP URL:" UCP_URL
[ -z "$DUSER" ] && read -p "Username:" DUSER
[ -z "$PASSWORD" ] && read -s -p "Password:" PASSWORD

echo
echo "Authenticating..."
# use your UCP username and password to acquire a UCP API auth token
data=$(echo {\"username\": \"$DUSER\" ,\"password\": \"$PASSWORD\" })
AUTHTOKEN=$(curl -sk -d "${data}" https://${UCP_URL}/auth/login | python -c "import sys, json; print json.load(sys.stdin)['auth_token']")

echo $AUTHTOKEN
# make your life easy by creating a curl alias that automatically uses your auth token:
alias ucp-api='curl -sk -H "Authorization: Bearer $AUTHTOKEN"'

curl -sk -H "Authorization: Bearer $AUTHTOKEN" https://${UCP_URL}/api/swarm

# download and initialize the client bundle authorizing action based on the permissions of the user who fetched the auth token above
echo "Obtaining clientbundle"
mkdir -p ~/.docker/${UCP_URL}/${DUSER}; cd ~/.docker/${UCP_URL}/${DUSER};
ucp-api https://${UCP_URL}/api/clientbundle -o bundle.zip
unzip -oq bundle.zip
eval "$(<env.sh)"
cd ~-

echo "Successful"

# all docker and kubectl commands are now issued to your UCP cluster, instead of the local node. To undo this, run:
# unset DOCKER_TLS_VERIFY COMPOSE_TLS_VERSION DOCKER_CERT_PATH DOCKER_HOST
