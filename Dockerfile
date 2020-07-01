FROM debian AS builder
RUN apt-get update && apt-get install -y debootstrap
RUN mkdir -p /rootfs
RUN debootstrap --foreign --arch=i386 squeeze /rootfs

FROM scratch
COPY --from=builder /rootfs /
RUN /debootstrap/debootstrap --second-stage
RUN apt-get update
RUN apt-get install --yes --force-yes curl git nano tar wget
RUN apt-get install --yes --force-yes apache2 php5 libapache2-mod-php5 php5-curl php5-gd php5-mssql php5-mysql freetds-bin tdsodbc unixodbc

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
EXPOSE 80
WORKDIR /var/www
VOLUME /var/www
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
