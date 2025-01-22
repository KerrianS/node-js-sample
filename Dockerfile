# Build stage
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer toutes les dépendances
RUN npm install

# Copier le reste des fichiers
COPY . .

# Rendre bin/www exécutable
RUN chmod +x bin/www

# Stage final
FROM node:18-alpine

# Créer un utilisateur non-root
RUN addgroup -S nodeapp && \
    adduser -S nodeapp -G nodeapp

WORKDIR /usr/src/app

# Copier les fichiers depuis le builder
COPY --from=builder --chown=nodeapp:nodeapp /usr/src/app .

# Rendre bin/www exécutable à nouveau
RUN chmod +x bin/www && \
    chown -R node:node .

# Utiliser l'utilisateur node
USER node

# Exposer le port correct
EXPOSE 8080

# Définir la commande de démarrage
CMD ["./bin/www"]
