FROM mysql:5.7

RUN echo 'secure_file_priv=""' >> /etc/mysql/mysql.conf.d/mysqld.cnf
