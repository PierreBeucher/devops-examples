echo "Make sure REGISTRATION_TOKEN variable is set"
echo
echo "Registering runner Simple Docker in Docker"

curl --request POST https://gitlab.com/api/v4/runners \
  --form "token=$REGISTRATION_TOKEN" \
  --form "description=Simple Docker in Docker" \
  --form "tag_list=dind-simple" \
  --form "run_untagged=false"

echo
echo "Registering runner Shared host Docker daemon"

curl --request POST https://gitlab.com/api/v4/runners \
  --form "token=$REGISTRATION_TOKEN" \
  --form "description=Shared host Docker daemon" \
  --form "tag_list=shared-host-dockerd" \
  --form "run_untagged=false"

echo
echo "Registering runner Remote secured Docker daemon"

curl --request POST https://gitlab.com/api/v4/runners \
  --form "token=$REGISTRATION_TOKEN" \
  --form "description=Remote secured Docker daemon" \
  --form "tag_list=remote-dockerd" \
  --form "run_untagged=false"

echo
