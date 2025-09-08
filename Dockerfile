# Pin a stable Node base (avoid :latest)
FROM node:20-bullseye-slim

# System deps for native modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 make g++ ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app/medusa

# Install deps with cache
COPY package.json yarn.lock ./
RUN yarn config set registry https://registry.npmjs.org \
 && yarn install --frozen-lockfile --non-interactive --network-timeout 600000

# Copy the rest
COPY . .

# Optional CLI
RUN yarn global add @medusajs/medusa-cli

# Build
RUN yarn build

# Startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 9000

# IMPORTANT: let EasyPanel inject runtime envs; don't bake empty defaults
# (No ARG/ENV block here unless you set real defaults)

# Use JSON form, call our script
CMD ["sh", "-lc", "start.sh"]
