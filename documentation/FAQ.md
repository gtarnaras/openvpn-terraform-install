
## FAQs

Below is a list of frequently asked questions.

### I Cannot SSH Into the OpenVPN Server Any Longer!

Most likely, the IP address of your machine executing the Terraform module has changed since the original installation. The security groups for the OpenVPN server are designed to only permit SSH access from a single predefined IP address. As this has drifted from the original value, you are being refused SSH access. But this scenario has been incorporated into the design of the Terraform module.

Just re-run the `./terraform-apply.sh` Bash script again with your `<input-file-name>`. Terraform should pick up your new IP address and update the ingress rules for the security groups accordingly.

### Why Is There no Route 53/DNS Support for Custom Domains?

Custom domains are great for running an OpenVPN server at [vpn.how-hard-can-it.be](vpn.how-hard-can-it.be). However, depending on the domain, its age, and many other factors, a provider may choose to _not resolve_ the domain which leaves the OpenVPN server unreachable when it may be needed the most.

Standard AWS URLs such as [ec2-1-2-3-4.eu-west-2.compute.amazonaws.com](ec2-1-2-3-4.eu-west-2.compute.amazonaws.com) tend to be resolved by most providers. It's probably not the most memorable URL but it tends to work in the places I personally care about.

### How Do I Configure OpenVPN Access on My Mac?

Please refer to the excellent guide on [Downloading and Installing Tunnelblick](https://tunnelblick.net/cInstall.html).

### How Do I Configure OpenVPN Access On My iPhone?

Please refer to the excellent guide on how to [Install OpenVPN on iOS](https://www.ovpn.com/en/guides/ios).
For transferring `.ovpn` configurations onto your iPhone, please refer to [Transfer Files to Your Mobile By Scanning a QR Code](https://www.how-hard-can-it.be/transfer-files-to-your-mobile-by-scanning-a-qr-code/).

### How Do I Configure OpenVPN Access On My Android phone?

Please refer to the excellent [Guide to install OpenVPN Connect for Android](https://www.ovpn.com/en/guides/android).
For transferring `.ovpn` configurations onto your Android phone, please refer to [Transfer Files to Your Mobile By Scanning a QR Code](https://www.how-hard-can-it.be/transfer-files-to-your-mobile-by-scanning-a-qr-code/).
 
### How do I Add or Remove Users from a Provisioned OpenVPN Server?

Simply add or remove the users from the list of `ovpn_users` in your `settings/<input-file-name>.tfvars` input file and re-run `./terraform-apply.sh <input-file-name>` as described above.

### Why is There no Load Balancing?

This Terraform module has been deliberately kept simple. It's intended for personal use and to reclaim some lost privacy, security, and freedom. If you require professional or enterprise level VPN services, then there is a sheer abundance of [commercial VPN providers](https://en.wikipedia.org/wiki/Comparison_of_virtual_private_network_services) to choose from.

This isn't to say that it wouldn't be a fun project to put the OpenVPN servers behind ASGs and ALBs and spin up bastion hosts on demand. However, this makes the key handling a bit more complicated. If you're interested, reach out and we can discuss over a pint.

On a side note: From personal experience, a single node OpenVPN cluster has served my digital family with a handful of more of less permanently connected devices well on a daily base over the course of the past six months. And running.

### Why Is Terraform Also Being Used for User Provisioning and Maintenance?

In one word: simplicity.

Terraform is great for provisioning (fairly static) infrastructure but there are more sophisticated tools out there for provisioning and maintaining elastic infrastructure at scale, let alone user provisioning and maintenance. For sake of simplicity, Terraform is being used as the single tool of choice in this case.

### Wait — There's a Pint Bounty in the Code?!

Yes. Find it. Solve it. Bag your reward. I'm looking forward to your solutions! Teach me something new!
