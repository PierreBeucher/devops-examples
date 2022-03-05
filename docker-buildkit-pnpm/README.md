# Docker build optimization using BuildKit and cache mount

Example usage of [BuildKit](https://github.com/moby/buildkit) [cache mount](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#build-mounts-run---mount) and [`pnpm`](https://pnpm.io/) for efficient dependency download and image build.

## Usage

Requires Docker 20+

### Build with plain Docker

```
docker build -f Dockerfile.nobuildkit .
```

### Build with BuildKit cache mount and `pnpm`

```
docker buildx build .
```

See [Dockerfile](./Dockerfile) for detailed setup.

## Observed results

With a network speed of approximatively ~1MB/s using Ubuntu 20.04, 16Go RAM and 8x1.80GHz CPUs

|                                      | Classic Docker build | BuildKit with cache mounts |
|-------------------------------------:|:--------------------:|:--------------------------:|
| No cache                             | 106s                 | 90s                        |
| Dependency install cache invalidated | 92s                  | 20s                        |

