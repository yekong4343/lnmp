#!/bin/sh

. $(pwd)/include.sh

$PWD_9377/centos6-lib.sh

#ulimit -SHn 65535

yum install -y ntp
ntpdate time.windows.com
hwclock -w

#ulimit
sed -i -r 's|#+\*(\s+)soft(\s+)core(\s+)0|*\1soft\2core\30|' /etc/security/limits.conf
sed -i -r 's|#+\*(\s+)hard(\s+)rss(\s+)10000|*\1hard\2rss\310000|' /etc/security/limits.conf

#selinux
sed -i -r 's|^SELINUX=.+|SELINUX=disabled|' /etc/selinux/config

cat <<EOD >> /etc/security/limits.conf

#####
*	soft	nofile	65535
*	hard	nofile	65535

*	soft	nproc	65535
*	hard	nproc	65535

root	soft	nproc	65535
root	hard	nproc	65535

root	soft	nofile	65535
root	hard	nofile	65535
#
#mysql	soft	nproc	65500
#mysql	hard	nproc	65500
#
#mysql	soft	nofile	65500
#mysql	hard	nofile	65500
#
www	soft	nproc	65535
www	hard	nproc	65535

www	soft	nofile	65535
www	hard	nofile	65535

#####
EOD




#network

#sed -i 's|net\.ipv4\.tcp_max_tw_buckets = \d\+|net.ipv4.tcp_max_tw_buckets = 30000|' /etc/sysctl.conf

cat <<EOD >> /etc/sysctl.conf



#####
net.ipv4.tcp_max_syn_backlog = 819200
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768
#
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
#
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
#
net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_tw_len = 1
#net.ipv4.tcp_tw_reuse = 1
#
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
#
#net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024  65535
net.ipv4.ip_conntrack_max = 10240
#
net.netfilter.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_tcp_timeout_established = 28800
#
net.ipv4.tcp_max_tw_buckets = 30000

net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0

net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_reordering = 5
net.ipv4.tcp_retrans_collapse = 0

#####

EOD

sysctl -p





















#su wheel
sed -i -r 's|#auth(\s+)required(\s+)pam_wheel.so|auth\1required\1pam_wheel.so|g' /etc/pam.d/su
sed -i -r 's|#auth(\s+)sufficient(\s+)pam_wheel.so|auth\1sufficient\1pam_wheel.so|g' /etc/pam.d/su


#ssh
sed -i -r 's/^#?PubkeyAuthentication\s+(yes|no)/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i -r 's|^#?AuthorizedKeysFile(\s+)\.ssh/authorized_keys|AuthorizedKeysFile\1.ssh/authorized_keys|' /etc/ssh/sshd_config
sed -i -r 's/^#?PasswordAuthentication\s+(yes|no)/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i -r 's/^#?PermitEmptyPasswords\s+(yes|no)/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i -r 's/^#?ClientAliveInterval\s+[0-9]+/ClientAliveInterval 30/' /etc/ssh/sshd_config
sed -i -r 's/^#?ClientAliveCountMax\s+[0-9]+/ClientAliveCountMax 30/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/^GSSAPI/#GSSAPI/g' /etc/ssh/sshd_config


ssh-keygen -t dsa -b 1024 -f ~/.ssh/id_dsa -P ""

if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 0700 ~/.ssh
fi

cp -a ~/.ssh/id_dsa.pub ~/.ssh/authorized_keys
restorecon -R -v ~/.ssh/

#enable root to login
sed -i -r 's/#?PermitRootLogin\s+(yes|no)/PermitRootLogin yes/' /etc/ssh/sshd_config


/etc/init.d/sshd reload

echo '------------------------save your key-------------------------'
cat id_dsa
echo '------------------------save your key-------------------------'
#rm -f key key.pub


#iptables restart
sed -i -r 's#IPTABLES_MODULES_UNLOAD="yes"#IPTABLES_MODULES_UNLOAD="no"#g' /etc/sysconfig/iptables-config

useradd www
mkdir /home/www/.ssh/ && chmod 0700 /home/www/.ssh/
touch /home/www/.ssh/authorized_keys && chmod 0600 /home/www/.ssh/authorized_keys
chown www:www /home/www/.ssh/ -R
mkdir /www && chown www:www /www

useradd log_syncer
mkdir /home/log_syncer/.ssh/ && chmod 0700 /home/log_syncer/.ssh/
touch /home/log_syncer/.ssh/authorized_keys && chmod 0600 /home/log_syncer/.ssh/authorized_keys
chown log_syncer:log_syncer /home/log_syncer/.ssh/ -R
usermod -G www -a log_syncer

mkdir /data0/mysql/

cp $PWD_9377/sh/9_login.sh /etc/profile.d/


cat <<EOD >> /etc/mail.rc

#9377ed
set from=mail_9377@163.com smtp=smtp.163.com
set smtp-auth-user=mail_9377 smtp-auth-password=m4i1_9377 smtp-auth=login
EOD



cat <<EOT >> /etc/profile


export PREFIX_9377=$PREFIX
EOT
