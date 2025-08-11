# Stage 1: Build Stage
FROM node:lts-alpine AS builder

# Enable and prepare pnpm
RUN corepack enable pnpm
RUN corepack prepare pnpm@latest --activate
    
WORKDIR /app/sooperwizer
COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build:production -F frontend

# Stage 2: Runtime Stage
FROM node:lts-alpine

# Enable and use pnpm
RUN corepack enable pnpm && corepack prepare pnpm@latest --activate

# Set working directory
WORKDIR /app/sooperwizer

# Copy the build artifacts from the build stage
COPY --from=builder /app/sooperwizer/apps/frontend/build ./apps/frontend/build
COPY --from=builder /app/sooperwizer/apps/frontend/package.json ./apps/frontend/package.json

WORKDIR /app/sooperwizer/apps/frontend
# Start the application
CMD ["npm", "start"]