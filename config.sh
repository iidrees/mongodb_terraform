#!/bin/bash


set -ex 

# System update
system_update () {
    printf "+++++++++++++++++++++++++++++++++++++++ SYSTEM UPDATE BEGINS +++++++++++++++++++++++++++++++++++++++"
    sudo yum -y update
    printf "+++++++++++++++++++++++++++++++++++++++ SYSTEM UPDATE ENDS +++++++++++++++++++++++++++++++++++++++"
}

setup_mongodb_repo () {
    printf "+++++++++++++++++++++++++++++++++++++++ BEGINS MONGODB REPO CONFIG +++++++++++++++++++++++++++++++++++++++"

    # create the repo config file that allows the package manager run installation

    sudo bash -c 'cat > /etc/yum.repos.d/mongodb-org-4.2.repo  <<EOF
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF'

    printf "+++++++++++++++++++++++++++++++++++++++ COMPLETES MONGODB REPO CONFIG +++++++++++++++++++++++++++++++++++++++"
}

# Install the MongoDB package
install_mongodb () {
    printf "+++++++++++++++++++++++++++++++++++++++ BEGINS MONGODB INSTALLATION +++++++++++++++++++++++++++++++++++++++"
    
    sudo yum -y install mongodb-org

    printf "+++++++++++++++++++++++++++++++++++++++ COMPLETE MONGODB INSTALLATION +++++++++++++++++++++++++++++++++++++++"
}

#  Mount the EBS Volumes 
mount_disk_drive () {
    printf "+++++++++++++++++++++++++++++++++++++++ BEGINS MONGODB DISK MOUNT +++++++++++++++++++++++++++++++++++++++"

    sudo mkfs.xfs -L mongodata /dev/sdf
    sudo mkfs.xfs -L mongojournal /dev/sdg
    
    sudo mkdir /data
    sudo mkdir /journal
    
    sudo mount -t xfs /dev/sdf /data
    sudo mount -t xfs /dev/sdg /journal
    
    sudo ln -s /journal /data/journal
    sudo chown mongod:mongod /data
    
    sudo chown mongod:mongod /journal/

    printf "+++++++++++++++++++++++++++++++++++++++ COMPLETE MONGODB DISK MOUNT +++++++++++++++++++++++++++++++++++++++"
}


# Create file that would be used for disk partition
setup_disk_partition () {
    printf "+++++++++++++++++++++++++++++++++++++++ CREATE FILE FOR DISK PARTITIONS +++++++++++++++++++++++++++++++++++++++"

    
    sudo sh -c "echo '/dev/sdf /data    xfs defaults,auto,noatime,noexec 0 0'  >> /etc/fstab"
    
    sudo sh -c "echo '/dev/sdh /log     xfs defaults,auto,noatime,noexec 0 0'  >> /etc/fstab"

    printf "+++++++++++++++++++++++++++++++++++++++ COMPLETE CREATE FILE DISK PARTITIONS +++++++++++++++++++++++++++++++++++++++"
}


#  Configure transparent huge pages
config_thp () {
    printf "+++++++++++++++++++++++++++++++++++++++ DISABLE TRANSPARENT HUGE PAGES  +++++++++++++++++++++++++++++++++++++++"


    # sudo bash -c 'cat > /etc/init.d/disable-transparent-hugepages <<EOF
    sudo sh -c "cat  /tmp/disable-transparent-hugepages | tee /etc/init.d/disable-transparent-hugepages"

    sudo chmod 755 /etc/init.d/disable-transparent-hugepages

    # sudo chmod 755 /etc/init.d/disable-transparent-hugepages
    printf "+++++++++++++++++++++++++++++++++ DISABLE TRANSPARENT HUGE PAGES COMPLETES ++++++++++++++++++++++++++++++++++++"
}


# Edit mongod.conf file 
inline_sed_word_replacement () {

    # Replace the storage file path /var/lib/mongo with /data
    sudo sed -i  's/\/var\/lib\/mongo/\/data/' /etc/mongod.conf

    # Replace the localhost IP address with the universal IP address
    sudo sed -i  's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
}

#  restart mongo
restart_mongo () {
    sudo chkconfig mongod on

    sudo service mongod start
}

system_update
setup_mongodb_repo
install_mongodb
mount_disk_drive
setup_disk_partition
config_thp
inline_sed_word_replacement
restart_mongo