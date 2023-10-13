FROM debian:bookworm as fai-mk-configspace
RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list
RUN apt update && apt install -y fai-quickstart apt-cacher-ng
RUN fai-mk-configspace
# Thanks to https://raw.githubusercontent.com/ricardobranco777/docker-fai/master/Dockerfile

FROM debian:bookworm
COPY --from=fai-mk-configspace /srv/fai/config /fai-mk-configspace
RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list

# Install packages
RUN	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y apt-cacher-ng \
		fai-quickstart openssh-server- openssh-client
	# 	apt-transport-https \
	# 	aptitude \
	# 	binutils \
	# 	bzip2 \
	# 	ca-certificates \
	# 	fai-client \
	# 	fai-server isc-dhcp-server- nfs-kernel-server- openbsd-inetd- tcpd- tftpd-hpa- update-inetd- \
	# 	debian-archive-keyring \
	# 	gawk \
	# 	grub-pc-bin \
	# 	less \
	# 	liblz4-tool \
	# 	memtest86+ \
	# 	patch \
	# 	reprepro \
	# 	tzdata \
	# 	vim \
	# 	wget \
	# 	xorriso \
	# 	xz-utils && \
	# apt-get clean

RUN apt-get install -y lsb-release

# Configuration
RUN rm /etc/apt/sources.list.d/debian.sources
RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs) 				main" > /etc/apt/sources.list
RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs)-updates 		main" >> /etc/apt/sources.list
RUN echo "deb http://127.0.0.1:9999/debian-security/ 	$(lsb_release -cs)-security 	main" >> /etc/apt/sources.list
RUN echo "deb http://fai-project.org/download bookworm koeln" >> /etc/apt/sources.list
# find and replace deb.debian.org with 127.0.0.1:9999 in 
RUN	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
	sed -ri 's/^Remap-(gentoo|sfnet):/#&/' /etc/apt-cacher-ng/acng.conf && \
	echo "http://deb.debian.org/debian" > /etc/apt-cacher-ng/backends_debian
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
RUN cp /etc/apt/sources.list /etc/fai/apt/
# Apply some patches
# RUN	patch /usr/sbin/fai-cd < /tmp/fai-cd.patch && \
# 	patch /usr/bin/fai-mirror < /tmp/fai-mirror.patch && \
# 	patch /usr/sbin/fai-make-nfsroot < /tmp/fai-make-nfsroot.patch && \
# 	rm -f /tmp/fai-cd.patch /tmp/fai-make-nfsroot.patch /tmp/fai-mirror.patch \
# 		/usr/sbin/fai-make-nfsroot.orig /usr/bin/fai-mirror.orig /usr/sbin/fai-cd.orig

# Add these volumes to speed up fai-setup & fai-mirror
RUN /etc/init.d/apt-cacher-ng start && apt update  && apt install -y dosfstools mtools wait-for-it

# RUN /etc/init.d/apt-cacher-ng start && apt update && apt install -y nfs-common rpcbind rsync lshw procinfo dump reiserfsprogs xfsprogs xfsdump btrfs-progs hwinfo hdparm smartmontools nvme-cli rdate zile numactl udns-utils netcat-traditional nmap pxelinux syslinux-common ca-certificates usbutils pciutils ssh netselect mdadm live-boot- initramfs-tools- -generic sysvinit-core systemd-sysv- curl lftp less ntpdate dosfstools lvm2 psmisc dialog console-common kbd xz-utils pigz grub-pc grub-efi-amd64-bin efibootmgr linux-image-amd64 fdisk gpg
CMD	test -n "pa.archive.ubuntu.com" && \
	/etc/init.d/apt-cacher-ng start && \
	/bin/bash
