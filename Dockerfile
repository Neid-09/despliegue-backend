# =============================================================================
# Dockerfile — Imagen de producción para practica-backend (NestJS)
# =============================================================================

# --- Etapa 1: Build ---
FROM node:20-alpine AS builder

WORKDIR /app

# Instalación reproducible de dependencias (respeta package-lock.json)
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# --- Etapa 2: Runner (producción) ---
FROM node:20-alpine AS runner

WORKDIR /app

# Entorno de producción
ENV NODE_ENV=production

# Solo dependencias de producción (sin devDependencies)
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copia los archivos compilados desde la etapa de build
COPY --from=builder /app/dist ./dist

# Comando de arranque apuntando al entry point compilado de NestJS
CMD ["node", "dist/main"]

# Puerto por defecto
EXPOSE 8080
