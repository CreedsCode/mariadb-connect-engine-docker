FROM mariadb:10.6.8

LABEL version="1.0"

# https://mariadb.org/download/?t=repo-config&d=20.04+%22focal%22&v=10.6&r_m=23Media
RUN apt update && apt-get install apt-transport-https curl -y && curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc' && sh -c "echo 'deb https://mirror.netcologne.de/mariadb/repo/10.6/ubuntu focal main' >>/etc/apt/sources.list"

# https://mariadb.com/kb/en/installing-the-connect-storage-engine/
RUN apt-get install mariadb-plugin-connect -y

EXPOSE 3306

CMD ["mysqld"]
