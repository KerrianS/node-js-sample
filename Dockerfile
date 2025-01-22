# Build stage
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer toutes les dépendances
RUN npm install

# Copier le reste des fichiers
COPY . .

# Stage final
FROM node:18-alpine

WORKDIR /usr/src/app

# Copier les fichiers depuis le builder
COPY --from=builder /usr/src/app .

# Changer les permissions
RUN chown -R node:node .

# Utiliser l'utilisateur node
USER node

# Exposer le port
EXPOSE 8080

# Définir la commande de démarrage en utilisant node directement
CMD ["node", "./bin/www"]