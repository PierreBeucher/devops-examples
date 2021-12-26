# Docker build optimization using BuildKit and cache mount

Demonstrate usage of BuildKit and Docker frontend cache mount features to speed-up image build.

## Related blog-posts and articles

To be published

## Observed results

With a network speed of approximatively ~1MB/s using Ubuntu 20.04, 16Go RAM and 8x1.80GHz CPUs

|                                      | Classic Docker build | BuildKit with cache mounts |
|-------------------------------------:|:--------------------:|:--------------------------:|
| No cache                             | 106s                 | 90s                        |
| Dependency install cache invalidated | 92s                  | 20s                        |
| Full cache                           | 1s                   | 1s                         |


## Usage

Requires Docker 20+

## Build with plain Docker

```
docker build -f Dockerfile.nobuildkit .
```

## Build with BuildKit cache export/import and cache mount

First build and export cache:

```
docker buildx build . \
    --cache-to type=local,dest=/tmp/mycache \
    --cache-from type=local,src=/tmp/mycache
```

Prune all cache to ensure local cache won't be reused, only the cache we'll specify with `--cache-from`:

```
docker buildx prune -af
```

Re-run our build command:

```
docker buildx build . \
    --cache-to type=local,dest=/tmp/mycache \
    --cache-from type=local,src=/tmp/mycache
```

Cache is re-used as shown in output like:

```
 => CACHED [stage-0 2/6] RUN npm -g i 
 => CACHED [stage-0 3/6] COPY package.json pnpm-lock.yaml
 => CACHED [stage-0 4/6] WORKDIR                0.0s
 => CACHED [stage-0 5/6] RUN --mount=type=cache,id=pnmcache,target=/pnpm_store [...]
 => CACHED [stage-0 6/6] COPY . /app 
```

Run `prune` and same build command without `--cache-from` won't have any cache re-used. 