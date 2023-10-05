# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags ON Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag
```sh
git push -- delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history

```sh
git checkout <SHA>
git tag M.M.P.
git push --tags
git checkout main
```

## Root Module Structure

Our root module structure is as follows:

PROJECT_ROOT
│
├── variables.tf - stores the structure of input variables
├── main.tf - everything else
├── providers.tf - defines required providers and their configuration
├── outputs.tf - stores our outputs
├── terraform.tfvars - the data of variables we want to load into our terraform project
└── README.md - required for root modules


[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables
### Terraform Cloud Variables

In terraform, we can set two kinds of variables.
    - Environment Variables - those that you would set in your bash terminal eg. AWS credentials
    - Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so that they are not shown visibly in the UI

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid`="my-user_id"

### var-file flag
We can use the `var-file` flag to specify variable values in a variable definitions file

### terraform.tfvars

This is the default file to load in terraform variables in bulk

### auto.tfvars
Files ending in `auto.tfvars` can automatically loads a number of variable definitions files if they are present: 

### order of terraform variables
- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

## Dealing With Configuration Drift

## What happens if we lose our state file

If you lose your state file, you most likely have to tear down all of your cloud infrastructure manually.

You can use Terraform import, but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

##
### Fix Missing Resources With Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through Clickops.

If we run Terraform plan again, it will attempt to put our infrastructure back into the expected state, fixing configuration drift

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a modules directory when locally developing modules but you can name it whatever you'd like.

### Passing Input Variables

We can pass input variables to our module

The module has to declare the terraform variables in its own variables.tf

```tf
module " terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg: 
    -locally
    -Github
    Terraform Registry

```tf
module " terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLM's such as ChatGPT may not be trained on the latest documentation or information about Terraform

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with files in Terraform

### Fileexists function

This is a built in terraform function to check these existence of a file

```tf
condition = fileexists(var.index_html_filepath)
```

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform, there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references)

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"

  etag = filemd5(var.index_html_filepath)
}

## Terraform Locals

Locals allow us to define local variables. It can be very useful when we need to transform data into another format and have referenced a variable.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows us to source data from cloud sources. 

This is useful when we want to reference cloud resources without importingg them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Source](https://developer.hashicorp.com/terraform/language/data-sources)

## Working JSON

We use the jsonencode to create the json policty inline in the hcl.
```
> jsonencode({"hello"="world"})
{"hello":"world"}

```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

## Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because configuration management tools such as Ansible are a better fit but the functionality exists

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
### Local-exec

This will execute a command on the machine running the terraform commands eg. plan apply 

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  connection {
    type = "ssh"
    user = "root"
    password = var.root_password
    host = self.public_ip
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## ForEach Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly userful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code

[ForEach Expressions](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

