#!/usr/bin/env bash

usage()
{
    echo "usage: set_me_up.sh -r us-east-1 -c ~/.aws/credentials -p default -u userOne,userTwo"
    echo "-r : REGION: aws region, e.g. aws-east-1"
    echo "-c : AWS_CREDENTIALS: aws credentials, usually under ~/.aws/credentials"
    echo "-p : AWS_PROFILE: aws profile, specify your aws profile to use"
    echo "-u : OVPN_USER_PROFILES: comma seperated list of ovpn user settings to crate, e.g. userOne,userTwo"

}

populate_settings()
{
cat << EOF > settings/custom_settings.tfvars
##############
# AWS Settings
##############

aws_region = "${REGION}"

shared_credentials_file = "${CREDS}"

profile = "${PROFILE}"

ovpn_users = [${USERS}]
EOF
}

execute_setup()
{
    echo "Setting up terraform"
    ./terraform-bootstrap.sh
    ./terraform-apply.sh custom_settings
}

###########################################
#############     MAIN    #################
###########################################

unset option
while getopts r:c:p:u:h option
do
    case ${option} in
        r)
            REGION=${OPTARG}
        ;;
        c)
            CREDS=${OPTARG}
        ;;
        p)
            PROFILE=${OPTARG}
        ;;
        u)
            USERS=${OPTARG}
            certNumber=$(echo ${USERS} | tr -cd , | wc -c)
            certNumber=$((certNumber+1))
            certString=""
            for i in $(seq "$certNumber")
            do
                extra=$(echo $USERS | cut -d"," -f${i})
                certString+=\"$extra\",
                echo $extra
            done
            USERS=$(echo $certString | sed 's/,$//')
        ;;
        *)
            usage
            exit 1
        ;;
    esac
done

if [ ! "$REGION" ] || [ ! "$CREDS" ] || [ ! "$PROFILE" ] || [ ! "$USERS" ]
then
    usage
    exit 1
fi

populate_settings
execute_setup