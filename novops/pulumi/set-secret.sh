#!/usr/bin/env sh

# Used to set secrets in dev vault instance with Compose

vault kv put -format=json --mount=secret app/dev pulumi_passphrase='d3vP@ssphrase!' ssh_key='xxx'
vault kv put -format=json --mount=secret app/prod pulumi_passphrase='pr0dP@ssphrase!' ssh_key='xxx'