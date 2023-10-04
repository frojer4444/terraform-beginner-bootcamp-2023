# Terraform Beginner Bootcamp 2023 - Week 1

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

