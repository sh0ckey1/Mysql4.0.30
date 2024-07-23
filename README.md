docker build -t mysql:4.0.30 .

docker run -d --name mysql-4.0.30 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_SERVER_ID=1 mysql:4.0.30