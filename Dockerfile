# Production image for Railway
# Uses Node.js 22 LTS to match better-sqlite3 13.x requirements.
FROM node:22-bookworm-slim

WORKDIR /app

# Install server dependencies first for better Docker layer caching.
COPY server/package*.json ./server/
WORKDIR /app/server
RUN npm ci --omit=dev

# Copy application code.
COPY server/src ./src
COPY client /app/client

ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm", "start"]
