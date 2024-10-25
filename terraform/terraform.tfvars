aws_region = "us-east-1"
aws_access_key = ${{ secrets.AWS_ACCESS_KEY_ID }}
aws_secret_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}
vpc_id = "vpc-05b1b5ad0c86820c9"
subnet_id = "subnet-09a45ccf4d1419369,subnet-07011400bdaa8928a,subnet-0489436a55167ec93"
security_group_id = "sg-0eb6874861ddecab8"
docker_image = "bepoadewale/hello-world:latest"
