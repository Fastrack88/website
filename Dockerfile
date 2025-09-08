# Dockerfile
FROM node:20-bullseye-slim

# Build deps for native modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash python3 make g++ ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /server

# Cache dependencies
WORKDIR /server
COPY package.json yarn.lock ./
RUN yarn config set registry https://registry.npmjs.org \
 && yarn install --frozen-lockfile --non-interactive --network-timeout 600000


# Copy app
COPY . .

# Ensure start.sh is executable & no CRLF
RUN sed -i 's/\r$//' /server/start.sh && chmod +x /server/start.sh

# Build app (uses your "build" script)
RUN yarn build

EXPOSE 9000

# Run under bash (never node)
CMD ["/usr/bin/env", "bash", "-lc", "/server/start.sh"]
