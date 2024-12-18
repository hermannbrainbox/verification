# Étape 1 : Utiliser une image de base officielle Node.js
FROM node:14

# Étape 2 : Créer un répertoire de travail dans le conteneur
WORKDIR /app

# Étape 3 : Copier les fichiers du projet dans le conteneur
COPY . .

# Étape 4 : Installer les dépendances de l'application
RUN npm install

# Étape 5 : Exposer le port que l'application utilise (exemple : 8080)
EXPOSE 8080

# Étape 6 : Démarrer l'application
CMD ["npm", "start"]
