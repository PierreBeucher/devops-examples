# Docker build optimization with GitLab CI

A few examples of Docker build optimization. This small project contains GitLab runner configuration each used to apply a CI optimization pattern. It works in conjunction with [GitLab project Docker Build CI optimization](https://gitlab.com/crafteo/devops-examples/docker-build-ci-optimization/-/blob/master/.gitlab-ci.yml):

## Patterns

### Simple Docker in Docker

Runner: `Simple Docker in Docker`
Job: `dind-simple` and `dind-pull-before`

Using Docker in Docker on CI, simply pull Docker image and use its cache before building.

### Share Docker daemon with underlying host to re-use cache

Runner: `Shared host Docker daemon`
Job: `shared-dockerd`

Share underlying host Docker daemon so that CI jobs always use the same daemon: no need for DinD and easy cache re-use on runner!

### Remote Docker daemon shared between multiple runners

Runner: `Remote secured Docker daemon`
Job: `remote-dockerd`

Share a remotely accessible (and secured!) Docker daemon between runners. No need for DinD and easy cache re-use with multiple runners!

### Save build cache locally for your build tool (example with `pnpm`)

Runner: `Remote secured Docker daemon` or `Shared host Docker daemon`
Job: `buildkit-pnpm-cache`

Optimize your tooling to keep your favourire build tool cache (such as pnpm or Maven) in a Docker volume

## Usage

Use a registration token and run registration script which will give you a token for each runner:

```
export REGISTRATION_TOKEN=xxx
./register-runners.sh
```

Replace each token in `gitlab-runner-config.toml` accordingly and run Gitlab Runner container:

```
docker-compose up -d
```

Check your runner started properly with

```
docker-compose logs gitlab-runner
```

## Docker Daemon with TLS

Running remote secured Docker daemon requires a bit more config:

```
cd dockerd-tls
```

Generate TLS server certificates  (used by Docker daemon) and client certificate:

```
# Generate certificates
./generate-docker-certs.sh
```

With Docker Compose:

```
docker-compose up -d

unset DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS
export DOCKER_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dockerd_tls):2376
export DOCKER_CERT_PATH=$PWD/.tls/client
export DOCKER_TLS=1
```

With Ansible: deploy an EC2 instance and install Docker with daemon configured to use TLS with our certificate

```
ansible-playbook playbook.yml

unset DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS
export DOCKER_HOST=tcp://x.y.z.z:2376
export DOCKER_CERT_PATH=$PWD/.tls/client
export DOCKER_TLS=1
```

Cleanup:

```
ansible-playbook playbook.yml -e docker_state=absent
```