## Terrahome AWS

```
module "home_metalgear" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  #bucket_name = var.bucket_name
  public_path = var.metalgear_public_path
  #index_html_filepath = var.index_html_filepath
  #error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  #assets_path = var.assets_path
}
```

The public directory expects the following
- index.html
- error.html
-assets

All top level files in assets will be copied, but not any subdirectories