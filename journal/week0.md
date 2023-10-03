# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Consdierations with the Terraform CLI changes](#consdierations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Consierations](#execution-consierations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle--before--init--command-)
- [Working Env Vars](#working-env-vars)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
    + [Terraform Lock Files](#terraform-lock-files)
    + [Terraform State Files](#terraform-state-files)
    + [Terraform Directory](#terraform-directory)
- [Issues with Terraform CLoud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)


The general format:

**MAJOR**, eg. `1.0.1`

- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Consdierations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu. Please consider checking your Linux Distribution and change accordingly to distribution needs

[How To Check OS Versin in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version:
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprication issues, we noticed that bash script steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File tidy ([.gitpod.yml](.gitpod.yml)).
- This will allow us an easier time to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI

#### Shebang Considerations

A Sheband (pronounced Sha-bang) tells the bash script what program will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended we use this format for bash: `#!/user/bin/env bash`

- for portability for different OS distributions
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Consierations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml, we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable, we need to change linx permissions for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively
```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle

We need to be careful when using the Init because it will not rerun if we restart an existing workspace. 

https://www.gitpod.io/docs/configure/workspaces/tasks

## Working Env Vars

### env command

We can list out all Environment Variables (Env Vars) using thte `env` command

We can filter sprecifc env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO+'world'`

In the terminal we can unset using `unset HELLO`
We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writng export tg. HELLO='world'

```sh
#1/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $Hello`

## AWS CLI Installation

AWS CLI is installed for this project via the bash script. [`./bin/install_aws_cli`](./bin/install_aws_cli)
readme


[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following command
```sh
aws sts get-caller-identity
```
If it is successful, you should see a json payload return that looks like this:

```json
{   "UserId": "AIEAQB5GCU1D5ZTZDHICO",
    "Account": "004173506503",
    "Arn": "arn:aws:iam::004173506503:user/terraform-beginner-bootcamp"

}
```

We'll need to generate AWS CLI credentials from IAM user in order to use the AWS CLI


## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to API's that will allow you to create resources in terraform
- **Modules** are a way to make large amounts of terraform code modular, portable, and shareable

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

### Terraform Console

We can see a list of all the terraform commands by simply typing 'terraform'

#### Terraform Init

At the start of a new terraform project we will run 'terraform init' to download the binaries for the terraform providers that we'll use in this project

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed. We can ouput this changeset i.e. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt us yes or no. If we want to automatically approve an apply we can provide the auto approve flag e.g. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`
This will destroy resources. You can also use the auto approve flag to skip the approve prompt eg. `terraform apply --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project. The terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructre. Thie file **should NOT be committed** to your VCS. This file can contain sensitive data. If you lose this file, you lose knosing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers

## Issues with Terraform CLoud Login and Gitpod Workspace

When attempting to run `terraform login`, it will launch in bash a wysiwyg view to generate a token. However it doesn't work as expected in Gitpod VsCode in the broswer. 

```
The workaround is to manually generate a token in Terraform cloud.

```

Then create and open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
terraform {
  cloud {
    organization = "Icario"

    workspaces {
      name = "terra-house-1"
    }
  }
}
```

We have automated this workaround with the following bash script [bin/generated_tfrc_credentials](bin/generate_tfrc_credentials)







