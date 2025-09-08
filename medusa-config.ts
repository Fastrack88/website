// medusa-config.ts
import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

export default defineConfig({
  // DB + core project settings
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL!, // required
  },

  // HTTP/server settings (no redisUrl here)
  http: {
    storeCors: process.env.STORE_CORS ?? "",
    adminCors: process.env.ADMIN_CORS ?? "",
    authCors: process.env.AUTH_CORS ?? "",
    jwtSecret: process.env.JWT_SECRET ?? "supersecret",     // OK for dev only
    cookieSecret: process.env.COOKIE_SECRET ?? "supersecret", // OK for dev only
    // jwtOptions, compression, etc. can also live here if needed
  },

  // Redis-backed modules
  modules: {
    eventBus: {
      resolve: "@medusajs/event-bus-redis",
      options: {
        redisUrl: process.env.REDIS_URL!,
      },
    },
    cacheService: {
      resolve: "@medusajs/cache-redis",
      options: {
        redisUrl: process.env.REDIS_URL!,
      },
    },
  },
})
