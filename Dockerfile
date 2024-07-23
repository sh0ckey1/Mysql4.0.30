FROM cuteribs/dsm-ubuntu1604
MAINTAINER yanling_280501

ARG MYSQL_VER="4.0.30" WORK_DIR="/usr/local/src"

ENV MYSQL_ROOT_PASSWORD=root MYSQL_SERVER_ID=1

ADD mysql-${MYSQL_VER}.tar.gz ${WORK_DIR}/

COPY entrypoint.sh /

COPY sources.list /etc/apt/sources.list

# apt update
RUN apt-get update \
# install dependencies
  && apt-get install -y gcc-5 g++-5 make libncurses5-dev \
  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5 \
# setup
  && useradd -r mysql \
  && cd ${WORK_DIR}/mysql-${MYSQL_VER} \
  && ./configure --prefix=/usr/local/mysql \
  && make \
  && make install \
  && cp support-files/my-medium.cnf /etc/my.cnf \
  && sed -i "s/^log-bin/log-bin=\/usr\/local\/mysql\/binlog\/mysql-bin/" /etc/my.cnf \
  && cd /usr/local/mysql \
  && mkdir binlog \
  && chown -R mysql binlog \
  && bin/mysql_install_db --user=mysql \
  && chown -R root . \
  && chown -R mysql var \
  && chown -R mysql binlog \
  && chgrp -R mysql . \
  && cp -p /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && chmod +x /entrypoint.sh 

VOLUME ["/usr/local/mysql/var/mysql/"]

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh", "-c", "/usr/local/mysql/bin/mysqld_safe --user=mysql --server-id=$MYSQL_SERVER_ID"]

