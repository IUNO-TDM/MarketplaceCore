FROM node:20-slim

WORKDIR /usr/src/app

COPY MarketplaceCore-app/package.json MarketplaceCore-app/package-lock.json ./
RUN npm install --omit=dev

COPY MarketplaceCore-app/ ./

RUN chown -R node:node /usr/src/app

# Uploaded recipe images; mount a volume to persist them
VOLUME /usr/src/app/images/recipes

# Configuration is read from environment variables only:
# DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD KEYCLOAK_INTERNAL_URL KEYCLOAK_REALM
# BACKEND_CLIENT_ID BACKEND_CLIENT_SECRET LOG_LEVEL PORT
ENV PORT=3002 NODE_ENV=production
EXPOSE 3002

USER node
CMD ["node", "./bin/www"]
