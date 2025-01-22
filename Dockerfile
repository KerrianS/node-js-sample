# Build stage
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install --production

# Copier le reste des fichiers
COPY . .

# Stage final
FROM node:18-alpine

# Créer un utilisateur non-root
RUN addgroup -S nodeapp && \
    adduser -S nodeapp -G nodeapp

WORKDIR /usr/src/app

# Copier les fichiers depuis le builder
COPY --from=builder --chown=nodeapp:nodeapp /usr/src/app .

# Utiliser l'utilisateur non-root
USER nodeapp

# Exposer le port correct
EXPOSE 8080

# Définir la commande de démarrage
CMD ["npm", "start"]
