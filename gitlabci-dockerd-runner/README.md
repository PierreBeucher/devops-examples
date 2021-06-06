# GitlabCI Docker Daemon runner

Example configuration for a Gitlab runner using underlying host Docker Daemon.

Requirements:

- Linux host with Docker installed

## Setup

Retrieve an Authentication token by running below command. You must replace `REGISTRATION_TOKEN` with a valid registration token. (see [Registering Runners](https://docs.gitlab.com/runner/register/#docker) and [Runners API](https://docs.gitlab.com/ee/api/runners.html#register-a-new-runner)):

```sh
curl --request POST https://gitlab.com/api/v4/runners \
  --form "token=REGISTRATION_TOKEN" \
  --form "description=Docker Daemon runner" \
  --form "tag_list=dockerd" \
  --form "run_untagged=false"

# Response looks like
# {"id":1234567,"token":"xxx"}
```

In `gitlab-runner/config.toml`, set `token` value to returned token such as `token = "xxx"`

Start the runner with:

```
docker-compose up -d
```

Check your runner started properly with

```
docker-compose logs gitlab-runner
```

Your runner should now appear in Gitlab. It can used to run jobs tagged `dockerd`.

For usage, see  [Crafteo `gitlabci-dockerd-runner` on Gitlab](https://gitlab.com/crafteo/devops-examples/gitlabci-dockerd-runner)

## Cleanup

Stop the runner:

```
docker-compose down
```

You may want to remove the runner from Gitlab once it has been stopped. 