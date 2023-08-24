#!/usr/bin/env sh

clear

sleep 1

source demo/demo-magic.sh -n

# Set some options
DEMO_PROMPT="[~/novops-demo]$ "
TYPE_SPEED=25

p
p " # Novops fetch and generate secrets defined in .novops.yml"
p " # Let's load a password, a private SSH key and generate temporary AWS credentials ✨"
pei "nano .novops.yml"

p
p " # Run a sub-process with secrets loaded in memory 🔒"
p "novops run sh"
novops run -- demo/novops-run-dev.sh 

p
p " # Now deploy in Prod 🚀"
pei "novops run -e prod -- make deploy"

p
p " # Secrets are available only for as long command runs and discarded on exit"

sleep 3