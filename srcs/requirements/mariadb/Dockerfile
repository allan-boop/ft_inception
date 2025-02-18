FROM debian:bullseye

# Mise à jour et installation des paquets
RUN apt update -y && \
    apt upgrade -y && \
    apt-get install -y --no-install-recommends vim mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Configuration des permissions et des répertoires
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    chmod 750 /var/run/mysqld /var/lib/mysql

# Exposer le port MySQL
EXPOSE 3306

# Définition d'un volume pour persister les données
VOLUME /var/lib/mysql
RUN mkdir -p /docker-entrypoint-initdb.d/
# Copier les fichiers de configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
#ligne de merde qui fonction pas
COPY conf/init.sql /docker-entrypoint-initdb.d/init.sql
COPY conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 644 /docker-entrypoint-initdb.d/init.sql
# Rendre le script d'entrée exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir l'entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Lancer le serveur MariaDB
CMD ["mysqld", "--init-file=/docker-entrypoint.sh"]