
import sys, json, requests, wget
#import urllib2 import urlopen, URLError, HTTPError

def clientbundle():
  pass

url="https://ec2-54-183-194-88.us-west-1.compute.amazonaws.com/auth/login"
data = dict(username='docker', password='dockeradmin')
r = requests.post(url, json=data, verify=False)

auth_token = json.loads(r.content)["auth_token"]

headers = { 'Authorization': 'Bearer + ' + auth_token }
ucp_api = "https://ec2-54-183-194-88.us-west-1.compute.amazonaws.com/api/clientbundle"

target_path = 'bundle.zip'
handle = open(target_path, "wb")
response = requests.get(ucp_api, headers=headers, stream=True, verify=False)
for chunk in response.iter_content(chunk_size=512):
    if chunk:  # filter out keep-alive new chunks
        handle.write(chunk)
handle.close()

#wget.download(url)

