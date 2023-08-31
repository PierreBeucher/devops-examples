#!/usr/bin/env sh

set -e

# Small script to run everything and check it works

npm run build 
npm run test

npm run start &
APP_PID=$!

echo "App running with PID $APP_PID"

sleep 3
curl localhost:3000
pkill -P $APP_PID

mysql --version
terraform --version