terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.region
}

resource "aws_organizations_account" "account" {
  email = var.root_email
  name = var.account_name
  tags = var.tags
  close_on_deletion = true
}

resource "aws_budgets_budget" "cost" {
  name  = "SN-CAM-Monthly-Budget"
  count = var.monthly_budget > 0 ? 1 : 0
  budget_type  = "COST"
  limit_amount = var.monthly_budget
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  cost_filter {
    name = "LinkedAccount"
    values = [
      aws_organizations_account.account.id
    ]
  }
}
