# Run with:
# docker run [-e REPO=pa.archive.ubuntu.com] --privileged -it fai

FROM	ubuntu

# Redirection sites like http.debian.net or httpredir.debian.org don't seem to work well with apt-cacher-ng
ENV	MAIN_REPO	us.archive.ubuntu.com

# Add FAI repository and install GPG key
ADD	keys/074BCDE4.asc /tmp/
RUN	echo "deb http://fai-project.org/download jessie koeln" >> /etc/apt/sources.list && \
	apt-key add /tmp/074BCDE4.asc && \
	rm -f /tmp/074BCDE4.asc

# Install packages
RUN	sed -ri -e 's/^deb-src/#&/' -e '/[a-z]+-security/s/archive.ubuntu.com/security.ubuntu.com/' /etc/apt/sources.list && \
	sed -i "s/archive\.ubuntu\.com/${MAIN_REPO}/" /etc/apt/sources.list && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y apt-cacher-ng \
		apt-transport-https \
		aptitude \
		binutils \
		bzip2 \
		ca-certificates \
		fai-client=4.3.3 \
		fai-server=4.3.3 isc-dhcp-server- nfs-kernel-server- openbsd-inetd- openssh-server- tcpd- tftpd-hpa- update-inetd- \
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

ADD	fai /etc/fai/
ADD	hooks /etc/fai/nfsroot-hooks/
ADD	bin /usr/local/bin/
ADD	patches /tmp/
# Add FAI key downloaded from http://fai-project.org/download/074BCDE4.asc
ADD	keys /etc/fai/apt/keys/

# Configuration
RUN	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
	sed -ri 's/^Remap-(gentoo|sfnet):/#&/' /etc/apt-cacher-ng/acng.conf && \
	echo "http://us.archive.ubuntu.com/ubuntu" > /etc/apt-cacher-ng/backends_ubuntu && \
	. /etc/lsb-release && \
	sed -ri "s%^(FAI_DEBOOTSTRAP)=.*%\1=\"$DISTRIB_CODENAME http://$MAIN_REPO/ubuntu\"%" /etc/fai/nfsroot.conf && \
	cp /etc/apt/sources.list /etc/fai/apt/ && \
	sed -i 's%http://%&127.0.0.1:9999/%' /etc/fai/apt/sources.list && \
	mkdir -p /etc/fai/faimirror/apt && \
	cp /etc/fai/fai.conf /etc/fai/faimirror && \
	cp /etc/fai/nfsroot.conf /etc/fai/faimirror && \
	chmod +x /etc/fai/nfsroot-hooks/* && \
	chmod +x /usr/local/bin/*

# Apply some patches
RUN	patch /usr/sbin/fai-cd < /tmp/fai-cd.patch && \
	patch /usr/bin/fai-mirror < /tmp/fai-mirror.patch && \
	patch /usr/sbin/fai-make-nfsroot < /tmp/fai-make-nfsroot.patch && \
	rm -f /tmp/fai-cd.patch /tmp/fai-make-nfsroot.patch /tmp/fai-mirror.patch \
		/usr/sbin/fai-make-nfsroot.orig /usr/bin/fai-mirror.orig /usr/sbin/fai-cd.orig

# Add these volumes to speed up fai-setup & fai-mirror
VOLUME	/var/cache/apt-cacher-ng

CMD	test -n "$REPO" && sed -i -re "s/${MAIN_REPO}/${REPO}/" /etc/apt/sources.list /etc/fai/apt/sources.list /etc/fai/nfsroot.conf ; \
	/etc/init.d/apt-cacher-ng start && \
	/bin/bash
