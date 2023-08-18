#!/usr/bin/env bash
echo
echo "Initializing environment..."
echo "All OS packages are already installed, just need a few more things."
echo 

echo "Dummy Hashicorp Vault credentials and AWS endpoint are set for demo purpose."
echo "In real situation, you'd use your own credentials and Hashicorp Vault / AWS account"
echo "provided by your organization."
echo
export VAULT_TOKEN="rootToken"
export VAULT_ADDR="http://localhost:8200"
export AWS_ENDPOINT_URL="http://localhost:4566/"

echo "Installing Node dependencies..."

npm install

retValNpm=$?
if [ $retValNpm -ne 0 ]; then
    echo "Failed to install node dependencies. Check logs above for details."
    exit $retValNpm
fi

echo "Loading secrets as environment variables..."

novops load -s .envrc -e dev 

retValNovops=$?
if [ $retValNovops -ne 0 ]; then
    echo "Failed to load secrets via Novops. Check logs above for details."
    exit $retValNovops
fi

source ./.envrc

echo
echo "All ready 🥳 You can now build, start, test and deploy application."
echo "Try to run the following commands:"
echo
echo "  # Build and start application"
echo "  npm run [build|test|start]"
echo
echo "  # Check your current AWS authentication status"
echo "  aws sts get-caller-identity" 
echo 
echo "  # Reach vault"
echo "  vault status"
echo
echo "  # Other binaries available"
echo "  mysql --version"
echo "  terraform --version"
echo "  novops --version"

# Run additional command if passed as argument
"$@"