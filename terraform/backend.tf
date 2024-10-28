terraform {
  backend "s3" {
    bucket         = "eks-deploy-html-website-aws-autoscaling-group"
    region         = "us-east-1"
  }
}