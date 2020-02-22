# OpenVPN on AWS 

This repository contains a one-stop Terraform module that creates a single node [OpenVPN Server](https://en.wikipedia.org/wiki/OpenVPN) in a dedicated AWS VPC and subnet. The OpenVPN server is configured to be readily accessible by the users supplied in the Terraform input file. The same Terraform input file can be used to subsequently update the list of authorised users.

> For further information, see the corresponding article on [Ready to Use OpenVPN Servers in AWS For Everyone](https://www.how-hard-can-it.be/openvpn-server-install-terraform-aws/?utm_source=GitHub&utm_medium=social&utm_campaign=README) on [How Hard Can It Be?!](https://www.how-hard-can-it.be/?utm_source=GitHub&utm_medium=social&utm_campaign=README).

The master branch in this repository is compliant with [Terraform v0.12](https://www.terraform.io/upgrade-guides/0-12.html);

## Getting Started

### Prerequisites

Before you can use the Terraform module in this repository out of the box, you need

 - an [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html)
 - a [Terraform](https://www.terraform.io/intro/getting-started/install.html) CLI
 - a list of users to provision with OpenVPN access

Moreover, you probably had enough of people snooping on you and want some privacy back or just prefer to have a long lived static IP.

### QuickStart Installation

```
set_me_up.sh <region> <aws_credentials_file> <profile> <ovpn_users>

e.g. ./set_me_up.sh us-east-1 ~/.aws/credentials <default> <userone,usertwo>
```

The OpenVPN configuration file can be found under the following directory:
```
generated/ovpn-config/userOne.ovpn
```

You can either import it using the CLI
```
sudo openvpn --config generated/ovpn-config/userOne.ovpn 
```

Or just double click the .ovpn file using your window manager to import it...

## Architecture

The installation always use the latest Amazon_Linux_2 AMI, it does not make use of the Workplace's OpenVPN AMI. That means that the only
cost incurred is from the common AWS resources.

![Architecture](./documentation/Architecture.png)

## Setup

Comprehensive setup instructions can be found in the following section [Setup](./documentation/Setup.md)

## Credits

> Thanks https://www.how-hard-can-it.be/author/dominic/ for providing the initial code. This repo is a fork.

>This repository relies on the great [openvpn-install.sh](https://github.com/angristan/openvpn-install/blob/master/openvpn-install.sh) Bash script from [https://github.com/angristan/openvpn-install](https://github.com/angristan/openvpn-install) to do the OpenVPN plumbing under the bonnet. Keep up the good work, Stanislas Lange, aka [angristan](https://angristan.xyz/)!

## FAQ

See [FAQ](./documentation/FAQ.md)


## You Want

After running the Terraform module in this repository you get
 - an EC2 node running in a dedicated VPC and subnet
 - an OpenVPN server bootstrapped on the EC2 node by the excellent [openvpn-install.sh](https://github.com/angristan/openvpn-install/blob/master/openvpn-install.sh) Bash script from [https://github.com/angristan/openvpn-install](https://github.com/angristan/openvpn-install)
 - SSH access to the OpenVPN sever locked down to the IP address of the machine executing the Terraform module (see the FAQs for how to handle drift over time)
 - the list of users supplied as input to the Terraform module readily provisioned on the OpenVPN server
 - the configuration of each user supplied in the Terraform configuration downloaded onto the local machine and ready for use
 - the option to provision and revoke users from the OpenVPN server by simply re-running the Terraform module 