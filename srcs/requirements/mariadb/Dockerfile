FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt-get install -y vim mariadb-server mariadb-client && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

EXPOSE 3306

VOLUME /var/lib/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/init.sql /docker-entrypoint-initdb.d/


CMD ["bash", "-c", "mysqld_safe --init-file=/docker-entrypoint-initdb.d/init.sql"]