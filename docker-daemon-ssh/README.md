# Remote SSH Docker daemon

A Docker daemon remotely accessible via SSH.

Deployment on remote host `your-host`:
- Update `docker-compose.yml` with your SHS public key
- Run SSH server and Docker daemon:
  ```sh
  docker compose up -d
  ```

To use remote Docker daemon on client host:

```sh
# Docker will ssh into your-host via user 'docker'
export DOCKER_HOST=ssh://docker@your-host:2222

docker info
```

Docker client will use local SSH config. You can [customize your SSH config](https://www.ssh.com/academy/ssh/config), for example `~/.ssh/config` such as:

```
HostName dockerd.crafteo.io
User docker
IdentityFile ~/.ssh/docker_id_rsa
```

## GitLab CI setup

[`gitlab-ci/config.toml`](gitlab-ci/config.toml) contains an example GitLab CI Runner config using our SSH Docker daemon by providing all necessary variables and setup directly at runner level. It will ensure each job's container are running with:

- SSH private key allowing access to SSH Docker daemon
- `DOCKER_HOST` environment variable pointing to SSH Docker daemon
- Custom SSH config automatically picking SSH key to connect to daemon

Run locally with a command such as:

```sh
gitlab-runner run -c $PWD/gitlab-ci/config.toml --working-directory /tmp/gitlab
```

With such a runner, Docker build job is as simple as:

```yaml
docker-build:
  stage: build
  tags: [ dockerd-ssh ]
  image: docker
  script:
  - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
  - docker build . -t $CI_REGISTRY_IMAGE:latest
  - docker push $CI_REGISTRY_IMAGE:latest
```