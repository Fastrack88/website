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
 && yarn config set @medusajs:registry https://registry.npmjs.org \
 && npm config set registry https://registry.npmjs.org \
 && sed -i 's#https://registry.yarnpkg.com#https://registry.npmjs.org#g' yarn.lock

RUN for i in 1 2 3; do \
      yarn install --frozen-lockfile --non-interactive --network-timeout 600000 && break || \
      (echo "Retry $i/3 after failure..." && sleep 5); \
    done


COPY . .
COPY start.sh /usr/local/bin/start.sh
RUN sed -i 's/\r$//' /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh
CMD ["/usr/bin/env","bash","-lc","/usr/local/bin/start.sh"]


# Build app (uses your "build" script)
RUN yarn build

EXPOSE 9000

# Run under bash (never node)
CMD ["/usr/bin/env", "bash", "-lc", "/server/start.sh"]
