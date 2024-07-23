#!/bin/bash
waitStart(){
    # wait mysql start
    until /usr/local/mysql/bin/mysqladmin ping -h localhost; do
        echo "Waiting for MySQL to start..."
        sleep 1
    done

    # set root password
    /usr/local/mysql/bin/mysql -u root -e "grant all privileges on *.* to 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' with grant option;flush privileges;"
}

waitStart &

exec "$@"