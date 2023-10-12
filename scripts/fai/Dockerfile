FROM debian as fai-mk-configspace

RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bullseye koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list
RUN apt update && apt install -y fai-server fai-client fai-doc
RUN fai-mk-configspace
# Thanks to https://raw.githubusercontent.com/ricardobranco777/docker-fai/master/Dockerfile
FROM debian
COPY --from=fai-mk-configspace /srv/fai/config /fai-mk-configspace
# Redirection sites like http.debian.net or httpredir.debian.org don't seem to work well with apt-cacher-ng
ENV	MAIN_REPO	us.archive.ubuntu.com

RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bullseye koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list

# Install packages
RUN	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y apt-cacher-ng \
		apt-transport-https \
		aptitude \
		binutils \
		bzip2 \
		ca-certificates \
		fai-client \
		fai-server isc-dhcp-server- nfs-kernel-server- openbsd-inetd- openssh-server- tcpd- tftpd-hpa- update-inetd- \
		debian-archive-keyring \
		gawk \
		grub-pc-bin \
		less \
		liblz4-tool \
		memtest86+ \
		openssh-client \
		patch \
		reprepro \
		tzdata \
		vim \
		wget \
		xorriso \
		xz-utils && \
	apt-get clean

# get /etc/lsb-release
RUN apt-get install -y lsb-release
RUN echo lsb_release
# Configuration
RUN echo "deb http://127.0.0.1:9999/debian/ $(lsb_release -cs) main contrib" > /etc/apt/sources.list
RUN	export DISTRIB_CODENAME=$(lsb_release -cs) && \
	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
	sed -ri 's/^Remap-(gentoo|sfnet):/#&/' /etc/apt-cacher-ng/acng.conf && \
	echo "http://us.archive.ubuntu.com/ubuntu" > /etc/apt-cacher-ng/backends_ubuntu
	#  && \
	# sed -ri "s%^(FAI_DEBOOTSTRAP)=.*%\1=\"\"%" /etc/fai/nfsroot.conf && \
	# cp /etc/apt/sources.list /etc/fai/apt/
	#  && \
	# sed -i 's%http://%&127.0.0.1:9999/%' /etc/fai/apt/sources.list && \
	# mkdir -p /etc/fai/faimirror/apt && \
	# cp /etc/fai/fai.conf /etc/fai/faimirror && \
	# cp /etc/fai/nfsroot.conf /etc/fai/faimirror
    #  && \
	# chmod +x /etc/fai/nfsroot-hooks/* && \
	# chmod +x /usr/local/bin/*
RUN sed -i 's%^\(FAI_DEBOOTSTRAP\)=.*%\1="'$(lsb_release -cs)' http://127.0.0.1:9999/debian"%' /etc/fai/nfsroot.conf
RUN /etc/init.d/apt-cacher-ng start && apt update
RUN cp /etc/apt/sources.list /etc/fai/apt/
# Apply some patches
# RUN	patch /usr/sbin/fai-cd < /tmp/fai-cd.patch && \
# 	patch /usr/bin/fai-mirror < /tmp/fai-mirror.patch && \
# 	patch /usr/sbin/fai-make-nfsroot < /tmp/fai-make-nfsroot.patch && \
# 	rm -f /tmp/fai-cd.patch /tmp/fai-make-nfsroot.patch /tmp/fai-mirror.patch \
# 		/usr/sbin/fai-make-nfsroot.orig /usr/bin/fai-mirror.orig /usr/sbin/fai-cd.orig

# Add these volumes to speed up fai-setup & fai-mirror
VOLUME	/var/cache/apt-cacher-ng

CMD	test -n "pa.archive.ubuntu.com" && sed -i -re "s/${MAIN_REPO}/${REPO}/" /etc/apt/sources.list /etc/fai/apt/sources.list /etc/fai/nfsroot.conf ; \
	/etc/init.d/apt-cacher-ng start && \
	/bin/bash
