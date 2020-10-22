# Terraform AWS Lambda
Terraform configuration for an AWS infrastructure with Lambda functions

In order to run this project, you need to create an S3 Bucket and upload the zip files for the get and post.

You can zip the functions inside `lambda_functions/` and upload them in a v1.0.0 directory to s3. You can use the following command to upload them:

    aws s3 cp example.zip s3://terraform-serverless-example/v1.0.0/get.zip
    
 If you want to change the names of the zip files or the version name you can modify it in `terraform/modules/lambda/02-main.tf`. And to change the bucket name you can modify it in `terraform/01-variables.tf`.

 After having the files in your bucket, you can execute the following terraform commands to create the infrastructure 

    terraform init
    terraform apply
