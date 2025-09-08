# Pin a stable Node image (avoid :latest drift)
FROM node:20-bullseye-slim

# System deps for node-gyp / native modules and TLS
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 make g++ ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app/medusa

# Leverage Docker layer caching for deps
COPY package.json yarn.lock ./

# Yarn classic + use npmjs registry to avoid yarnpkg proxy 5xx
# (corepack won't hurt; if missing it just no-ops)
RUN corepack enable || true
RUN yarn config set registry https://registry.npmjs.org \
 && yarn install --frozen-lockfile --non-interactive --network-timeout 600000

# Copy the rest of the source *after* deps to keep cache hits
COPY . .

# Optional: global CLI (you had this)
RUN yarn global add @medusajs/medusa-cli

# Build your app
RUN yarn build

# (Optional) expose the default Medusa API port
EXPOSE 9000

# Accept build-time args from EasyPanel and surface as envs at runtime
ARG DATABASE_URL
ARG REDIS_URL
ARG JWT_SECRET
ARG COOKIE_SECRET
ARG NODE_ENV=production
ENV DATABASE_URL=${DATABASE_URL} \
    REDIS_URL=${REDIS_URL} \
    JWT_SECRET=${JWT_SECRET} \
    COOKIE_SECRET=${COOKIE_SECRET} \
    NODE_ENV=${NODE_ENV}

# Prefer JSON form; run migrations before starting
CMD ["sh","-lc","medusa migrations run && yarn start"]
