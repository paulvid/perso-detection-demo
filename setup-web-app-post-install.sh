#!/bin/bash

installUtils () {
	echo "*********************************Installing WGET..."
	yum install -y wget
	
	echo "*********************************Installing GIT..."
	yum install -y git
	
    echo "*********************************Installing Apache..."
	yum install -y httpd
    systemctl start httpd.service
    systemctl enable httpd.service
    export WEB_APP_IP=$(curl http://icanhazip.com)

    echo "*********************************Installing MySQL..."
	yum install -y mariadb-server mariadb
    systemctl start mariadb
    systemctl enable mariadb

    yum install -y expect

    export MYSQL_ROOT_PASSWORD='HWseftw33#'

    export SECURE_MYSQL=$(expect -c "
    set timeout 10
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"\r\"
    expect \"Set root password?\"
    send \"Y\r\"
    expect \"New password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Re-enter new password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Remove anonymous users?\"
    send \"Y\r\"
    expect \"Disallow root login remotely?\"
    send \"n\r\"
    expect \"Remove test database and access to it?\"
    send \"Y\r\"
    expect \"Reload privilege tables now?\"
    send \"Y\r\"
    expect eof
    ")

    echo "*********************************Installing PHP7..."
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum install -y yum-utils
    yum-config-manager --enable remi-php70
    yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
    echo "*********************************PHP version is $(php -v | head -1)..."
}


getHostByPosition (){
	HOST_POSITION=$1
	HOST_NAME=$(curl -u admin:HWseftw33#HWseftw33# -X GET http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts|grep -Po '"host_name" : "[a-zA-Z0-9_\W]+'|grep -Po ' : "([^"]+)'|grep -Po '[^: "]+'|tail -n +$HOST_POSITION|head -1)
	
	echo $HOST_NAME
}


installMySQL (){
	yum remove -y mysql57-community*
	yum remove -y mysql56-server*
	yum remove -y mysql-community*
	rm -Rvf /var/lib/mysql

	yum install -y epel-release
	yum install -y libffi-devel.x86_64
	ln -s /usr/lib64/libffi.so.6 /usr/lib64/libffi.so.5

	yum install -y mysql-connector-java*
	ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar


	if [ $(cat /etc/system-release|grep -Po Amazon) == Amazon ]; then       	
		yum install -y mysql56-server
		service mysqld start
		chkconfig --levels 3 mysqld on
	else
		yum localinstall -y https://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
		yum install -y mysql-community-server
		#yum localinstall -y https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
#yum install -y mysql-community-server
		systemctl start mysqld.service
		systemctl enable mysqld.service
	fi
}


#export AMBARI_HOST=$(hostname -f)
export AMBARI_HOST=`cat /etc/ambari-agent/conf/ambari-agent.ini | grep hostname= | sed s/hostname=//g`
export WEB_APP_HOST=$(hostname -f)
export CLUSTER_NAME=$(curl -u admin:HWseftw33#HWseftw33# -X GET http://$AMBARI_HOST:8080/api/v1/clusters |grep cluster_name|grep -Po ': "(.+)'|grep -Po '[a-zA-Z0-9\-_!?.]+')
export NIFI_HOST=$(curl -u admin:HWseftw33#HWseftw33#  -H "X-Requested-By: ambari" -X GET  http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/services/NIFI/components/NIFI_MASTER?fields=host_components/HostRoles/host_name | grep host_name\"\ \: | awk -F\" '{print $4}')
echo "*********************************AMBARI HOST IS: $AMBARI_HOST"
echo "*********************************WEB APP HOST IS: $WEB_APP_HOST"
echo "*********************************CLUSTER_NAME IS: $CLUSTER_NAME"
echo "*********************************NIFI HOST IS: $NIFI_HOST"

echo "*********************************Install Utilities..."
installUtils

echo "*********************************Loading MySQL..."
installUtils

echo "*********************************Download Configurations"
cd /var/www/html
git clone https://github.com/paulvid/personality_detection_demo_dashboard.git
cd personality_detection_demo_dashboard

export ROOT_PATH=`pwd`
echo "*********************************ROOT PATH IS: $ROOT_PATH"

echo "*********************************Running MySQL init"
mysql -u root -pHWseftw33# < $ROOT_PATH/init_scripts/load_db.sql

echo "*********************************Changing /etc/hosts"
echo "" >> /etc/hosts
echo ""`nslookup ip-172-31-29-213.ec2.internal | grep Address | grep 172 | awk '{print $2}'`" nifi-server" >> /etc/hosts

echo "*********************************Changing Apache Configuration"
cp $ROOT_PATH/init_scripts/httpd.conf /etc/httpd/conf/
chmod a+rw /etc/httpd/conf/httpd.conf
sed -i "s/perso-detection-webserver/"$WEB_APP_IP"/g" $ROOT_PATH/application/config/config.php

systemctl restart httpd