// medusa-config.ts
import { loadEnv, defineConfig } from "@medusajs/framework/utils"
loadEnv(process.env.NODE_ENV || "development", process.cwd())

export default defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL!,
    databaseDriverOptions: {
      ssl: false,
      sslmode: "disable",
    },
    http: {
      storeCors: process.env.STORE_CORS ?? "*",
      adminCors: process.env.ADMIN_CORS ?? "*",
      authCors: process.env.AUTH_CORS ?? "*",
      jwtSecret: process.env.JWT_SECRET ?? "supersecret",
      cookieSecret: process.env.COOKIE_SECRET ?? "supersecret",
      // NOTE: do NOT put redisUrl here
    },
  },

  modules: {
    // Uncomment if/when you want Redis-backed modules
    // eventBus: { resolve: "@medusajs/event-bus-redis", options: { redisUrl: process.env.REDIS_URL! } },
    // cacheService: { resolve: "@medusajs/cache-redis", options: { redisUrl: process.env.REDIS_URL! } },
  },
})
