# Multi-stage production Dockerfile for visitflow-agent-ai
FROM node:22-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code, prompts, and local knowledge base
COPY . .

# Build SvelteKit application for production
RUN npm run build

# Production runner stage
FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

# Copy package files and install production dependencies only
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built application and local knowledge/prompts
COPY --from=builder /app/build ./build
COPY --from=builder /app/knowledge ./knowledge
COPY --from=builder /app/prompts ./prompts
COPY --from=builder /app/static ./static

# Create data directory for persistent SQLite chat history
RUN mkdir -p /app/data

EXPOSE 3000

CMD ["node", "build"]
