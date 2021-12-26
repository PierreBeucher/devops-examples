# syntax=docker/dockerfile:1.3

FROM node:12-alpine

RUN npm -g i pnpm

COPY package.json pnpm-lock.yaml /app/
WORKDIR /app

RUN --mount=type=cache,id=pnmcache,target=/pnpm_store \
    pnpm config set store-dir /pnpm_store && \
    pnpm config set package-import-method copy && \
    pnpm i --prefer-offline --ignore-scripts --frozen-lockfile

# Copy remaining files
COPY . /app

# Setup entrypoint
ENTRYPOINT ["node", "index.js"]