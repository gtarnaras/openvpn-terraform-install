
## Setup

The minimal setup leverages as much of the default settings in [variables.tf](variables.tf) as possible. However some input is required.

### Providing SSH Keys

In order to bootstrap as well as manage the OpenVPN server, the Terraform module needs to SSH into the EC2 node. By default, it uses the public key in `settings/openvpn.pub` and the private key in `settings/openvpn`. Both can be created by executing the following command from the root directory of this repository
```
cd settings
ssh-keygen -f openvpn -t rsa
```
Here, hit return when prompted for a password in order to make the SSH keys passwordless.

### Configuring Your Settings

The minimum input variables for the module are defined in [settings/example.tfvars](settings/example.tfvars) to be
```hcl
aws_region = "<your-region>"

shared_credentials_file = "/path/to/.aws/credentials"

profile = "<your-profile>"

ovpn_users = ["userOne", "userTwo", "userThree"]
```
Here, you need to replace the example values with your settings.

Moreover, note that users `userOne`, `userTwo`, and `userThree` will be provisioned with access to the OpenVPN sever and their configurations downloaded to the default location `generated/ovpn-config`.

> Each user provisioned via input `ovpn_users` should preferably be defined as a single word (i.e., no whitespace), _consisting only of ASCII letters and numbers with underscores as delimiters_; in technical terms, each user should adhere to `^[a-zA-Z0-9_]+$`.

## Execution

All Terraform interactions are wrapped in helper Bash scripts for convenience.

### Initialising Terraform

Initialise Terraform by running
```
./terraform-bootstrap.sh
```

### Applying the Terraform Configuration

The OpenVPN server can be created and updated by running
```
./terraform-apply.sh <input-file-name>
```
where `<input-file-name>` references input file `settings/<input-file-name>.tfvars`.
When using input file [settings/example.tfvars](settings/example.tfvars) configured above, the command becomes
```
./terraform-apply.sh example
```
Under the bonnet, the `terraform-apply.sh` Bash script with input `example`
 - selects or creates a new workspace called `example`
 - executes `terraform apply` where the inputs are taken from input file `settings/example.tfvars`
 - does not ask for permission to proceed as it uses `-auto-approve` when running the underlying `terraform apply` command


## Terraform Outputs

By default, all `.ovpn` configurations for the users provisioned with access to the OpenVPN server in input `ovpn_users` are automatically downloaded to `generated/ovpn-config`.

Additionally, the Terraform module also outputs
 - the `ec2_instance_dns`
 - the `ec2_instance_ip` and
 - a `connection_string` that can be used to SSH into the EC2 node 

## Deletion

The OpenVPN server can be deleted by running
```
./terraform-destroy.sh <input-file-name>
```
where `<input-file-name>` again references input file `settings/<input-file-name>.tfvars`.
When using input file [settings/example.tfvars](settings/example.tfvars) configured above, the command becomes
```
./terraform-destroy.sh example
```

Under the bonnet, the `terraform-destroy.sh` Bash script with input `example`
 - selects the `example` workspace
 - executes `terraform destroy` where the inputs are taken from file `settings/example.tfvars`
 - _does ask for permission_ to proceed when running the `terraform apply` command


## Testing VPN Connectivity

Once the Terraform module execution has successfully completed, the connection to the OpenVPN can be tested as follows. 

> While below instructions are specific to a recent Mac using [Homebrew](https://brew.sh/) as a package manager, the actual underlying `openvpn` command should be fairly transferable to other platforms as well.

If not already present, install `openvpn` via `brew` by executing
```
brew install openvpn
```
Follow the instructions on screen and if the installation may need a little final nudge, try running
```
sudo brew services start openvpn
```
In case `openvpn` isn't readily available from the terminal after the installation above, a [StackOverflow answer](https://apple.stackexchange.com/a/233221) suggests to add the `openvpn` executable to the `$PATH` environment variable by executing
```
export PATH=$(brew --prefix openvpn)/sbin:$PATH
```
Assuming a valid OpenVPN configuration has been downloaded to `generated/ovpn-config/userOne.ovpn `, the connection can be tested by initiating the actual `openvpn` connection by running
```
sudo openvpn --config generated/ovpn-config/userOne.ovpn 
```
> Note that the above command will actually change your network settings and hence public IP.