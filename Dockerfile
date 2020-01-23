FROM php-zendserver:8.5

#adicionando dependencias 
RUN apt-get update && apt-get install -y wget unzip gcc make python-software-properties autoconf
RUN wget http://launchpadlibrarian.net/212189159/libmysqlclient18_5.6.25-0ubuntu1_amd64.deb
RUN dpkg -i libmysqlclient18_5.6.25-0ubuntu1_amd64.deb

#compilando OCI 8-2.0.12
COPY ./oci/ /tmp/

WORKDIR /tmp
RUN unzip instantclient-basic-linux.x64-11.2.0.4.0.zip -d /opt
RUN unzip instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /opt
RUN tar -xzf oci8-2.0.12.tgz

WORKDIR /opt/instantclient_11_2
RUN ln -s libclntsh.so.11.1 libclntsh.so
RUN ln -s libocci.so.11.1 libocci.so

WORKDIR /tmp/oci8-2.0.12
RUN /usr/local/zend/bin/phpize
RUN ./configure --with-oci8=instantclient,/opt/instantclient_11_2 --with-php-config=/usr/local/zend/bin/php-config
RUN make install

WORKDIR /var/www