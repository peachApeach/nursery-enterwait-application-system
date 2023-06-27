terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
  required_version = ">= 1.2.0"
}

#Lambda Function Default Assume Role
 data "aws_iam_policy_document" "assume_role" {
   statement {
     effect = "Allow"
 
      principals {
        type        = "Service"
        identifiers = [
          "lambda.amazonaws.com"
        ]
      }
 
      actions = [
        "sts:AssumeRole"
      ]
    }
 }

provider "aws" {
  region = "ap-northeast-2"
}