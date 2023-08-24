# Novops example: Pulumi

Example usage of [Novops](https://github.com/PierreBeucher/novops) with Pulumi

Every command must be run under Nix development shell:

```
nix develop
```

## Setup

Run Hashicorp Vault and LocalStack containers:

```
podman-compose up -d
```

## Showtime !

Run demo

```
./demo.sh
```