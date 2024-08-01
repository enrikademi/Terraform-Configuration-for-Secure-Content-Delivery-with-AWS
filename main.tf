terraform {
  required_providers {
    aws = "~> 4"
  }
  backend "s3" {
    key    = "iac/infastructure/terraform.tfstate"
    bucket = "terraform-tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment  = var.environment
      Project      = var.project_name
      ManagedBy    = "Terraform"
    }
  }
}


module "cdn" {
  source = "./modules/cdn"
  
  mediapackage_uuid_secret               = module.elemental_medialive.mediapackage_uuid_secret

}
