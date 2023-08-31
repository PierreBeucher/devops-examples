# Fully automated, reproducible and secure development environment

Run a fully ready development environment in a single command for reproducibility, efficiency, fast onboarding of new developers. 

This example showcases setup described in my [Automated, reproducible and secure development/CI environments](TODO URL) blog post series. 

Context: you're a developer working on a project including
- Typescript (NodeJS) application
- MySQL database
- Terraform deployment

You need a fully automated and reproducible environment for you and your team with:

- A **single action** (a command to run, a button to click) drops us into a **fully ready development environment**
- **Reproducibility.** Every developer and our CI must have the same version of each packages and testing deployment to avoid drift.
- **Minimal one-time setup.** You'll obviously need some manual one-time config for your personal secrets, `git clone` your project and such. Let's keep that to a minimum. 

Example to implement this pattern with Nix or containers:

## Nix

Fully-ready Nix development shell. 

Requirements:

- [Nix](https://nixos.org/)
- That's all. 

Run your development environment with Nix development shell:

```sh
nix develop
```

Nix may take a few moments to prepare the environment as it download and compile dependencies, but it's a one-time action. Next time your run `nix develop`, shell will start almost instantly. 

That's it ! 🥳 You now run in a fully provisioned environment to build, run, test and deploy application:

```sh
npm run build
npm run start # Open web browser at localhost:3000
npm run test

# Other packages are also available
mysql --version
terraform --version
```

### How does it work?

`flake.nix` describe our environment and required packages. Running `nix develop` drops un in a shell with all packages available. Thanks for `flake.lock` commited in Git, anyone cloning this repository and running `nix develop` will have the same set of packages available, ensuring proper automation and reproducibility. Try it out yourself !

To get further with Nix:
- [devenv](https://devenv.sh) - Setup development environment with Nix
- [Nix pills](https://nixos.org/guides/nix-pills/why-you-should-give-it-a-try) - Series of tutorials introducing to Nix
- [Nix first steps](https://nix.dev/tutorials/first-steps/) - Another series of tutorials to get started with Nix

## Containers

Fully-ready shell in container. 

Requirements:

- A container engine: [Podman](https://podman.io/) and [Podman Compose](https://github.com/ontainers/podman-compose) or [Docker](https://www.docker.com/)
- That's all.

Run development environment in container:

```sh
# Docker
docker-compose -f docker-compose.dev-container.yml build                # Build image
docker-compose -f docker-compose.dev-container.yml run dev-container    # Run development shell

# Podman
podman-compose -f docker-compose.dev-container.yml build                # Build image
podman-compose -f docker-compose.dev-container.yml run dev-container    # Run development shell
```

Image will take some time to build, but it's a one time action. Next time you run your development shell in container, it will start almost instantly. All you need to do it now to publish image in a container registry and share it with your team, and everyone will have the same development environment !

That's it 🥳 You now run in a fully provisioned environment to build, run, test and deploy application:

```sh
# npm commands
npm run build
npm run start
npm run test

# Other packages
mysql --version
terraform --version
novops --version
```

### How does it work?

[`Containerfile`](./Containerfile) and [`docker-compose.dev-container.yml`](./docker-compose.yml) describe how to build and run development container with expected packages. 

When building your image, every packages are installed and put in a container image. Once built, the same image can be re-used by you and your team to ensure everyone has the same development environment.

## Next steps: secret management, local deployment and dynamic environments

This example will be updated soon with secret management and local deployment examples. Star it ⭐ and add it to your watch list to keep in touch !