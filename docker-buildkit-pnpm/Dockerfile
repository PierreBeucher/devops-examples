# syntax=docker/dockerfile:1.3
#
# Optimized Dockerfile using BuildKit Dockerfile syntax
# Mind the #syntax=... header as it's important
# Otherwise Docker won't recognize BuildKit syntex
FROM node:17-alpine3.14

# pnpm is not installed in node image by default
# Alternatively you can build your own base image with it
RUN npm -g i pnpm

WORKDIR /app

# pnpm use a pnpm-lock.json instead of package-lock.json
COPY package.json pnpm-lock.yaml /app/

# Instruct pnpm to use store directory at /pnpm
# And copy dependencies from store instead of symlinking them
# This is required as cache mount will only be available
# during build time
# it's also possible to run commands such as
#   pnpm config set store-dir /pnpm_store
#   pnpm config set package-import-method copy 
# or use .npmrc
ENV NPM_CONFIG_STORE_DIR=/pnpm
ENV NPM_CONFIG_PACKAGE_IMPORT_METHOD=copy

# Mount pnpm cache at /pnpm (matching NPM_CONFIG_STORE_DIR)
# And run pnpm install
RUN --mount=type=cache,id=pnmcache,target=/pnpm \
  pnpm i --prefer-offline --ignore-scripts --frozen-lockfile

# Copy remaining files and setup command
COPY . /app
CMD ["node", "index.js"]