#!/bin/bash 

set -ex


#launch the EC2 instance
terraform_instance_launch () {

    # Initialise terraform. Before this command would work, ensure that you have a terraform installed
    # Run terraform in order to launch the instance
    terraform init
    
    terraform apply -auto-approve
}

# configure MongoDB 
instance_mongodb_provisioning () {
    CWD_CONFIG=`pwd`
    INSTANCE_IP_ADD=`terraform output -json instance_ip | jq '.[0]' | xargs`
    sudo cat $CWD_CONFIG/disable-transparent-hugepages | ssh -oStrictHostKeyChecking=no -i $HOME/.ssh/cp-devops.pem ec2-user@$INSTANCE_IP_ADD "cat > /tmp/disable-transparent-hugepages"


    sudo cat $CWD_CONFIG/config.sh | ssh -oStrictHostKeyChecking=no  -i $HOME/.ssh/cp-devops.pem ec2-user@$INSTANCE_IP_ADD "cat > /tmp/config.sh ; chmod 755 /tmp/config.sh; bash /tmp/config.sh"
}

# Call each each function
main () {
    terraform_instance_launch
    instance_mongodb_provisioning
}

main