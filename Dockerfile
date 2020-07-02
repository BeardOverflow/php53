FROM debian AS builder
RUN apt-get update && apt-get install --yes debootstrap
RUN mkdir -p /rootfs
RUN debootstrap --foreign --arch=i386 squeeze /rootfs

FROM scratch AS chroot
COPY --from=builder /rootfs /
RUN /debootstrap/debootstrap --second-stage
RUN echo 'deb http://archive.debian.org/debian squeeze-lts main' >/etc/apt/sources.list.d/lts.list
RUN apt-get update && apt-get dist-upgrade --yes --force-yes && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

FROM scratch
COPY --from=chroot / /
RUN apt-get update && apt-get install --yes --force-yes \
    curl git nano tar wget \
    apache2 php5 libapache2-mod-php5 \
    php5-curl php5-gd php5-mssql php5-mysql \
    freetds-bin tdsodbc unixodbc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
WORKDIR /var/www
VOLUME /var/www
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
