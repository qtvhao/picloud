FROM debian:bookworm as fai-mk-configspace

RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list
RUN apt update && apt install -y fai-server fai-client fai-doc
RUN fai-mk-configspace
# Thanks to https://raw.githubusercontent.com/ricardobranco777/docker-fai/master/Dockerfile
FROM debian:bookworm
COPY --from=fai-mk-configspace /srv/fai/config /fai-mk-configspace
# Redirection sites like http.debian.net or httpredir.debian.org don't seem to work well with apt-cacher-ng
ENV	MAIN_REPO	us.archive.ubuntu.com

RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list

# Install packages
RUN	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y apt-cacher-ng \
		fai-quickstart
	# 	apt-transport-https \
	# 	aptitude \
	# 	binutils \
	# 	bzip2 \
	# 	ca-certificates \
	# 	fai-client \
	# 	fai-server isc-dhcp-server- nfs-kernel-server- openbsd-inetd- openssh-server- tcpd- tftpd-hpa- update-inetd- \
	# 	debian-archive-keyring \
	# 	gawk \
	# 	grub-pc-bin \
	# 	less \
	# 	liblz4-tool \
	# 	memtest86+ \
	# 	openssh-client \
	# 	patch \
	# 	reprepro \
	# 	tzdata \
	# 	vim \
	# 	wget \
	# 	xorriso \
	# 	xz-utils && \
	# apt-get clean

# get /etc/lsb-release
RUN apt-get install -y lsb-release
RUN echo lsb_release
# Configuration
RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs) 				main" > /etc/apt/sources.list
RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs)-updates 		main" >> /etc/apt/sources.list
RUN echo "deb http://127.0.0.1:9999/debian-security/ 	$(lsb_release -cs)-security 	main" >> /etc/apt/sources.list
# find and replace deb.debian.org with 127.0.0.1:9999 in 
RUN rm /etc/apt/sources.list.d/debian.sources
RUN	export DISTRIB_CODENAME=$(lsb_release -cs) && \
	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
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
# RUN sed -i 's%^\(FAI_DEBOOTSTRAP\)=.*%\1="'$(lsb_release -cs)' http://127.0.0.1:9999/debian"%' /etc/fai/nfsroot.conf
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
# RUN /etc/init.d/apt-cacher-ng start && apt update && apt install -y accountsservice adduser adwaita-icon-theme bubblewrap coreutils cpp cpp-10\
#   dbus dbus-user-session dbus-x11 dconf-cli dconf-gsettings-backend\
#   dconf-service debconf dictionaries-common dmsetup dpkg emacsen-common\
#   evolution-data-server evolution-data-server-common fontconfig\
#   fontconfig-config fonts-dejavu-core gcc-10-base gcr gdm3\
#   gir1.2-accountsservice-1.0 gir1.2-atk-1.0 gir1.2-atspi-2.0\
#   gir1.2-freedesktop gir1.2-gck-1 gir1.2-gcr-3 gir1.2-gdesktopenums-3.0\
#   gir1.2-gdkpixbuf-2.0 gir1.2-gdm-1.0 gir1.2-geoclue-2.0 gir1.2-glib-2.0\
#   gir1.2-gnomebluetooth-1.0 gir1.2-gnomedesktop-3.0 gir1.2-graphene-1.0\
#   gir1.2-gstreamer-1.0 gir1.2-gtk-3.0 gir1.2-gweather-3.0 gir1.2-harfbuzz-0.0\
#   gir1.2-ibus-1.0 gir1.2-json-1.0 gir1.2-mutter-7 gir1.2-nm-1.0 gir1.2-nma-1.0\
#   gir1.2-pango-1.0 gir1.2-polkit-1.0 gir1.2-rsvg-2.0 gir1.2-soup-2.4\
#   gir1.2-upowerglib-1.0 gjs glib-networking glib-networking-common\
#   glib-networking-services gnome-backgrounds gnome-desktop3-data gnome-keyring\
#   gnome-session gnome-session-bin gnome-session-common gnome-settings-daemon\
#   gnome-settings-daemon-common gnome-shell gnome-shell-common\
#   gsettings-desktop-schemas gstreamer1.0-pipewire gstreamer1.0-plugins-base\
#   gstreamer1.0-plugins-good gtk-update-icon-cache hicolor-icon-theme\
#   hunspell-en-us init-system-helpers iso-codes libaa1 libaccountsservice0\
#   libacl1 libapparmor1 libarchive13 libargon2-1 libasound2 libasound2-data\
#   libaspell15 libassuan0 libasyncns0 libatk-bridge2.0-0 libatk1.0-0\
#   libatk1.0-data libatomic1 libatspi2.0-0 libattr1 libaudit-common libaudit1\
#   libavahi-client3 libavahi-common-data libavahi-common3 libavc1394-0\
#   libblkid1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcaca0 libcairo-gobject2\
#   libcairo2 libcamel-1.2-62 libcanberra-gtk3-0 libcanberra0 libcap-ng0 libcap2\
#   libcap2-bin libcdparanoia0 libcolord2 libcom-err2 libcrypt1 libcryptsetup12\
#   libcups2 libdatrie1 libdb5.3 libdbus-1-3 libdconf1 libdeflate0\
#   libdevmapper1.02.1 libdrm-amdgpu1 libdrm-common libdrm-intel1\
#   libdrm-nouveau2 libdrm-radeon1 libdrm2 libdv4 libdw1 libebackend-1.2-10\
#   libebook-1.2-20 libebook-contacts-1.2-3 libecal-2.0-1 libedata-book-1.2-26\
#   libedata-cal-2.0-1 libedataserver-1.2-25 libedataserverui-1.2-2 libedit2\
#   libegl-mesa0 libegl1 libelf1 libenchant-2-2 libepoxy0 libevdev2 libexpat1\
#   libffi7 libflac8 libfontconfig1 libfontenc1 libfreetype6 libfribidi0 libgbm1\
#   libgcc-s1 libgck-1-0 libgcr-base-3-1 libgcr-ui-3-1 libgcrypt20\
#   libgdata-common libgdata22 libgdk-pixbuf-2.0-0 libgdk-pixbuf-xlib-2.0-0\
#   libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgdm1 libgeoclue-2-0\
#   libgeocode-glib0 libgirepository-1.0-1 libgjs0g libgl1 libgl1-mesa-dri\
#   libglapi-mesa libgles2 libglib2.0-0 libglib2.0-bin libglib2.0-data libglvnd0\
#   libglx-mesa0 libglx0 libgmp10 libgnome-autoar-0-0 libgnome-bluetooth13\
#   libgnome-desktop-3-19 libgnutls30 libgoa-1.0-0b libgoa-1.0-common\
#   libgpg-error0 libgpm2 libgraphene-1.0-0 libgraphite2-3 libgssapi-krb5-2\
#   libgstreamer-gl1.0-0 libgstreamer-plugins-base1.0-0 libgstreamer1.0-0\
#   libgtk-3-0 libgtk-3-common libgudev-1.0-0 libgweather-3-16\
#   libgweather-common libharfbuzz-icu0 libharfbuzz0b libhogweed6\
#   libhunspell-1.7-0 libhyphen0 libibus-1.0-5 libical3 libice6 libicu67\
#   libidn2-0 libiec61883-0 libimobiledevice6 libinput-bin libinput10 libip4tc2\
#   libisl23 libjack-jackd2-0 libjavascriptcoregtk-4.0-18 libjbig0\
#   libjpeg62-turbo libjson-c5 libjson-glib-1.0-0 libjson-glib-1.0-common\
#   libk5crypto3 libkeyutils1 libkmod2 libkrb5-3 libkrb5support0 liblcms2-2\
#   libldap-2.4-2 libllvm11 libltdl7 liblz4-1 liblzma5 libmanette-0.2-0 libmd0\
#   libmm-glib0 libmount1 libmozjs-78-0 libmp3lame0 libmpc3 libmpdec3 libmpfr6\
#   libmpg123-0 libmtdev1 libmutter-7-0 libncurses6 libncursesw6 libnettle8\
#   libnm0 libnma-common libnma0 libnotify4 libnsl2 libnspr4 libnss3 libogg0\
#   libopenjp2-7 libopus0 liborc-0.4-0 libp11-kit0 libpam-modules\
#   libpam-modules-bin libpam-runtime libpam-systemd libpam0g libpango-1.0-0\
#   libpangocairo-1.0-0 libpangoft2-1.0-0 libpangoxft-1.0-0 libpciaccess0\
#   libpcre2-8-0 libpcre3 libphonenumber8 libpipewire-0.3-0\
#   libpipewire-0.3-modules libpixman-1-0 libplist3 libpng16-16\
#   libpolkit-agent-1-0 libpolkit-gobject-1-0 libprocps8 libprotobuf23\
#   libproxy1v5 libpsl5 libpulse-mainloop-glib0 libpulse0 libpython3-stdlib\
#   libpython3.9-minimal libpython3.9-stdlib libraw1394-11 libreadline8\
#   librest-0.7-0 librsvg2-2 librsvg2-common libsamplerate0 libsasl2-2\
#   libsasl2-modules-db libseccomp2 libsecret-1-0 libsecret-common libselinux1\
#   libsemanage-common libsemanage1 libsensors-config libsensors5 libsepol1\
#   libshout3 libslang2 libsm6 libsmartcols1 libsndfile1 libsoup-gnome2.4-1\
#   libsoup2.4-1 libspa-0.2-modules libspeex1 libsqlite3-0 libssl1.1\
#   libstartup-notification0 libstdc++6 libsystemd0 libtag1v5 libtag1v5-vanilla\
#   libtasn1-6 libtdb1 libtext-iconv-perl libthai-data libthai0 libtheora0\
#   libtiff5 libtinfo6 libtirpc-common libtirpc3 libtwolame0 libudev1\
#   libunistring2 libunwind8 libupower-glib3 libusb-1.0-0 libusbmuxd6 libuuid1\
#   libv4l-0 libv4lconvert0 libvisual-0.4-0 libvorbis0a libvorbisenc2\
#   libvorbisfile3 libvpx6 libvulkan1 libwacom-common libwacom2 libwavpack1\
#   libwayland-client0 libwayland-cursor0 libwayland-egl1 libwayland-server0\
#   libwebkit2gtk-4.0-37 libwebp6 libwebpdemux2 libwoff1 libwpe-1.0-1\
#   libwpebackend-fdo-1.0-1 libwrap0 libx11-6 libx11-data libx11-xcb1 libxau6\
#   libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0\
#   libxcb-randr0 libxcb-render0 libxcb-res0 libxcb-shm0 libxcb-sync1\
#   libxcb-util1 libxcb-xfixes0 libxcb-xkb1 libxcb1 libxcomposite1 libxcursor1\
#   libxdamage1 libxdmcp6 libxext6 libxfixes3 libxfont2 libxft2 libxi6\
#   libxinerama1 libxkbcommon-x11-0 libxkbcommon0 libxkbfile1 libxkbregistry0\
#   libxml2 libxmu6 libxmuu1 libxpm4 libxrandr2 libxrender1 libxshmfence1\
#   libxslt1.1 libxt6 libxtst6 libxxf86vm1 libz3-4 libzstd1 login lsb-base\
#   media-types mount mutter-common p11-kit p11-kit-modules passwd perl-base\
#   pinentry-gnome3 pipewire pipewire-bin policykit-1 procps python3\
#   python3-minimal python3.9 python3.9-minimal readline-common sensible-utils\
#   shared-mime-info sound-theme-freedesktop systemd systemd-sysv tar tzdata ucf\
#   udev upower util-linux x11-common x11-xkb-utils x11-xserver-utils\
#   xdg-dbus-proxy xkb-data xserver-common xwayland zlib1g
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt install -y nfs-common rpcbind rsync lshw procinfo dump reiserfsprogs xfsprogs xfsdump btrfs-progs hwinfo hdparm smartmontools nvme-cli rdate zile numactl udns-utils netcat-traditional nmap pxelinux syslinux-common ca-certificates usbutils pciutils ssh netselect mdadm dracut live-boot- initramfs-tools- dracut-config-generic dracut-network sysvinit-core systemd-sysv- curl lftp less ntpdate dosfstools lvm2 psmisc dialog console-common kbd xz-utils pigz grub-pc grub-efi-amd64-bin efibootmgr linux-image-amd64 fdisk gpg
# sed -i -re "s/${MAIN_REPO}/${REPO}/" /etc/apt/sources.list /etc/fai/apt/sources.list /etc/fai/nfsroot.conf ; 
CMD	test -n "pa.archive.ubuntu.com" && \
	/etc/init.d/apt-cacher-ng start && \
	/bin/bash
