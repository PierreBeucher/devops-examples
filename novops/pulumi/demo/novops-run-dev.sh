#!/usr/bin/env sh

source demo/demo-magic.sh -n

TYPE_SPEED=25

p " # Secrets from Hashicorp Vault"
pei "echo \$PULUMI_CONFIG_PASSPHRASE"

p
p " # Temporary AWS credentials generated as environment variables"
pei "echo \$AWS_ACCESS_KEY_ID"
p
pei "aws sts get-caller-identity"

p
p " # Files are not written to disk but in memory"
pei "echo \$APP_SSH_KEY"

p
p " # And plain text variables"
pei "echo \$PULUMI_STACK"

p
p " # Let's deploy !"
pe "make deploy"

p " # Exit shell once done. Secrets won't be persisted 🧹"
pei "exit" 