#!/bin/bash_profile
update-ca-trust enable
cp /etc/pki/tls/private/vault.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust extract

## enable and reload
systemctl daemon-reload
systemctl enable consul
systemctl enable vault
systemctl restart consul
systemctl restart vault
