# Fully automated development environment with packages and secrets

Example to run a fully provisioned development environment in a single command for reproducibility, efficiency, fast onboarding of new developers and proper security with temporary credentials. 

TODO add blog link

Context used:
- Typescript (NodeJS) application
- MySQL database
- Secrets are stored in [Hashicorp Vault](https://www.vaultproject.io/)
- Deployment is done on AWS via Terraform

But the pattern can be easily adapted with other languages and platforms :)

Running development environment will:

- Provision all packages: Typescript, NodeJS, MySQL client, Vault and AWS CLI, Terraform...
- Install NodeJS dependencies 
- Load secrets as environment variables with [Novops](https://github.com/PierreBeucher/novops):
  - MySQL password
  - Temporary AWS STS credentials for IAM Role

You **don't need any package** apart from short requirements below. 

## Nix

Fully-ready Nix development shell. 

Requirements:

- [Nix](https://nixos.org/)

Start demo infrastructure (Hashicorp Vault, MySQL and AWS via Localstack) as containers. They're used for demo purpose to emulate real pieces of infrastructure in order to load secrets and generate temporary AWS credentials. In real situations you'll likely use an Hashicorp Vault, MySQL and AWS account provided by your organization.

```
nix shell nixpkgs#podman-compose -c podman-compose up -d
```

Run development shell:

```sh
nix develop
```

Nix may take a few moments to prepare the environment, but it's a one-time action. Next time Nix run, shell will run almost instantly. 

That's it ! 🥳 You now run in a fully provisioned environment to build, run, test and deploy application:

```sh
# npm commands
npm run build
npm run start
npm run test

# Authenticated with AWS IAM Role
aws sts get-caller-identity

# Vault available
vault status

# Other packages
mysql --version
terraform --version
novops --version
```

Tear down infra containers once down:

```
podman-compose down -v
```

## Containers

Fully-ready shell in container. 

Requirements:

- [Podman](https://podman.io/) v4.3.1+ and [Podman Compose](https://github.com/ontainers/podman-compose) v1.0.6+
- Alternatively you can use [Docker](https://www.docker.com/) 23+, replace `podman-compose` by `docker compose` below

Start demo infrastructure (Hashicorp Vault, MySQL and AWS via Localstack) as containers. They're used for demo purpose to emulate real pieces of infrastructure in order to load secrets and generate temporary AWS credentials. In real situations you'll likely use an Hashicorp Vault, MySQL and AWS account provided by your organization.

```sh
podman-compose up -d
```

Run development environment in container:

```sh
podman-compose -f docker-compose.dev-container.yml run dev-container
```

That's it ! 🥳 You now run in a fully provisioned environment to build, run, test and deploy application:

```sh
# npm commands
npm run build
npm run start
npm run test

# Authenticated with AWS IAM Role
aws sts get-caller-identity

# Vault available
vault status

# Other packages
mysql --version
terraform --version
novops --version
```

Tear down infra containers once down:

```
podman-compose down -v
```

## How does it work?

Nix and Docker provide a shell with all packages available (NodeJS, Terraform, etc.)
- [`Dockerfile`](./Dockerfile) and [`docker-compose.dev-container.yml`](./docker-compose.yml) describe how to build and run development container with expected packages
- [`flake.nix`](./flake.nix) describe how to setup development shell with expected packages
- [`entrypoint.sh`](./entrypoint.sh) is run by Nix / Docker to generate **temporary secrets** as environment variable and files with [Novops](https://github.com/PierreBeucher/novops). They remain as long as the environment exists, and disappear on exit or after short expiration time. You'll still need your personal credentials to authenticate with Hashicorp Vault and AWS obviously, but they're provided for demo purpose. 

### Secret management

[Novops](https://github.com/PierreBeucher/novops) loads secrets from external sources: 
  - MySQL password is fetched from Hashicorp Vault - Vault is running as container but a real instance can be used
  - Temporary AWS credentials are generated using STS - Localstack is used for demo purpose, but a real AWS account works the same
  
See [`.novops.yml`](./.novops.yml) and [Novops doc](https://pierrebeucher.github.io/novops/intro.html) for details. 
 
### Demo infrastructure

Instead of "real" infrastructure for Hashicorp Vault, MySQL and AWS, setup provides services via [`docker-compose.yml`](./docker-compose.yml):

- [Hashicorp Vault](https://www.vaultproject.io/) development container
- MySQL container
- [LocalStack](https://localstack.cloud/), a containerized AWS emulator
- Dummy secrets are populated automatically in Vault by `vault-secret-setup` container in `docker-compose.yml`

This repo does not contain any sensitive data. Passwords and tokens are shown in plaintext for debugging and learning purpose. 