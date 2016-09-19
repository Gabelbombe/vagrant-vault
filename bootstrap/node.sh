## implements inputs from `script.args = config`

[[ -f /etc/consul/server/bind.json ]] || {
  echo '{ "bind_addr": "$1" }' >> /etc/consul/server/bind.json
}

openssl req -x509 -nodes -days 1825 -newkey rsa:2048 \
  -keyout /etc/pki/tls/private/vault.key             \
  -out /etc/pki/tls/private/vault.crt                \
  -subj "/C=SE/ST=/L=Stockholm/O=VaultedCorp/OU=/CN=$2"
