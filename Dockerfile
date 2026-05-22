# Stage 1: Install dependencies
FROM node:24.13.0-alpine AS builder
WORKDIR /app
RUN corepack enable
RUN corepack prepare pnpm@10.28.2 --activate
COPY package.json pnpm-lock.yaml ./
# Install dependencies with npm ci (faster, respects lockfile)
RUN pnpm install --frozen-lockfile --prod
COPY . .
RUN pnpm exec expo export -p web

# Stage 2: Production (using Nginx for better performance)
FROM nginx:alpine
# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html
# Copy custom nginx config for SPA routing and caching
RUN echo 'server { \
    listen 8000; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    # Enable gzip compression \
    gzip on; \
    gzip_vary on; \
    gzip_min_length 1024; \
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json; \
    \
    # Cache static assets \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
        access_log off; \
    } \
    \
    # SPA routing \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
