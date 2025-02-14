#!/bin/bash
set -e

# Vérifier si la base de données est déjà initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Initialisation de la base de données..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Démarrer MariaDB temporairement en arrière-plan
echo "🚀 Démarrage temporaire de MariaDB..."
mysqld --skip-networking --socket=/var/run/mysqld/mysqld.sock &
pid="$!"

# Attendre que le serveur soit prêt
echo "⏳ Attente de MariaDB..."
until mariadb --user=root --execute="SELECT 1;" &>/dev/null; do
    sleep 2
done

# Exécuter le script SQL si nécessaire
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo "📜 Exécution du script SQL d'initialisation..."
    mariadb -u root < /docker-entrypoint-initdb.d/init.sql
fi

# Arrêter proprement le serveur MariaDB
echo "🛑 Arrêt de MariaDB temporaire..."
mysqladmin --user=root shutdown

# Attendre la fin du processus MySQL
wait "$pid"

# Démarrer MariaDB en premier plan
echo "✅ Démarrage de MariaDB en mode normal..."
exec mysqld