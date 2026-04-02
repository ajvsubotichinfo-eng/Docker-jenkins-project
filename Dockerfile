# ─────────────────────────────────────────
# ETAPA 1: builder
# Usamos Node.js para compilar la app React.
# Esta etapa es TEMPORAL — no va a la imagen final.
# ─────────────────────────────────────────
FROM node:24-alpine AS builder

# Creamos y usamos esta carpeta dentro del contenedor
WORKDIR /app

# Copiamos primero SOLO los archivos de dependencias.
# Esto es una optimización: si no cambiaron, Docker
# reutiliza el cache y no reinstala todo cada vez.
COPY package.json package-lock.json ./

# Instalamos las dependencias
RUN npm install

# Ahora sí copiamos el resto del código fuente
COPY . .

# Compilamos la app — genera la carpeta /app/dist
RUN npm run build

# ─────────────────────────────────────────
# ETAPA 2: producción
# Usamos nginx para servir los archivos compilados.
# Esta es la imagen FINAL — liviana y sin código fuente.
# ─────────────────────────────────────────
FROM nginx:1.28-alpine

# Copiamos SOLO la carpeta /dist desde la etapa anterior.
# Todo lo demás (Node.js, node_modules, src/) queda afuera.
COPY --from=builder /app/dist /usr/share/nginx/html

# nginx escucha en el puerto 80 por defecto
EXPOSE 80