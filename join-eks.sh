# prompt for aws profile name
echo "Enter the name of the AWS profile you want to use"
read awsProfileName

# prompt for aws region
echo "Enter the AWS region you want to use"
read awsRegion

# Prompt for EKS cluster name
echo "Enter the name of the EKS cluster you want to join"
read eksClusterName

AWS_PROFILE=$(AWS_PROFILE) aws eks --region $(AWS_REGION) update-kubeconfig --name $(eksClusterName)
