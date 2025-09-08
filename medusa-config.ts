// medusa-config.ts
import { loadEnv, defineConfig } from "@medusajs/framework/utils"
loadEnv(process.env.NODE_ENV || "development", process.cwd())

export default defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL!,         // e.g. postgres://postgres:postgres@postgres:5432/medusa-store
    databaseDriverOptions: {
      ssl: false,                                    // disable SSL in local docker
      sslmode: "disable",
    },
  },
  http: {
    storeCors: process.env.STORE_CORS ?? "*",
    adminCors: process.env.ADMIN_CORS ?? "*",
    authCors: process.env.AUTH_CORS ?? "*",
    jwtSecret: process.env.JWT_SECRET ?? "supersecret",
    cookieSecret: process.env.COOKIE_SECRET ?? "supersecret",
  },
  modules: {
    // Optional in dev; recommended in prod:
    // eventBus: { resolve: "@medusajs/event-bus-redis", options: { redisUrl: process.env.REDIS_URL! } },
    // cacheService: { resolve: "@medusajs/cache-redis", options: { redisUrl: process.env.REDIS_URL! } },
  },
})
