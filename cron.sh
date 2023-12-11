#!/bin/bash

setenforce 0
sed -i -e 's/\(^SELINUX=\)enforcing$/\1disabled/' /etc/selinux/config		# SELINUX DISABLE

hostnamectl set-hostname $(dmidecode -s system-serial-number)

sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf 	# DOMAIN SETUP
echo 'ad_gpo_access_control = permissive' >> /etc/sssd/sssd.conf
authconfig --enablemkhomedir --enablesssdauth --updateall
sed -i 's;default_ccache_name = KEYRING:persistent:%{uid};default_ccache_name = FILE:/tmp/krb5cc_%{uid};g' /etc/krb5.conf
sed -i '/krb5cc_%{uid}/a default_realm = CRIMEA' /etc/krb5.conf

cp -f /tmp/additional_rncb/win_share/auto* /etc
systemctl enable autofs.service --now
 
/tmp/additional_rncb/infowatch/install.sh		# INFOWATCH SETUP

/tmp/additional_rncb/klnagent.sh						# KASPER SETUP
/tmp/additional_rncb/kesl-gui.sh

cp -f /tmp/additional_rncb/vncpasswd /etc/vncpasswd		# X11VNC SETUP
cp -f /tmp/additional_rncb/x11vnc.service /lib/systemd/system
systemctl daemon-reload
systemctl enable x11vnc.service --now

yum localinstall /tmp/additional_rncb/citrix.rpm -y			# CITRIX SETUP	

yum localinstall /tmp/additional_rncb/yandex-browser.rpm -y # Y.BROWSER SETUP
rm -rf /etc/yum.repos.d/yandex-browser.repo

yum localinstall /tmp/additional_rncb/librtpkcs11ecp.rpm -y
systemctl enable pcscd.service --now						# TOKENS SETUP
/tmp/additional_rncb/jacarta/install.sh

/tmp/additional_rncb/cryptopro/install.sh 					# CRYPTOPRO SETUP

echo 4 | /tmp/additional_rncb/tmx_cups/install.sh			# RECEIPT PRINTER SETUP
