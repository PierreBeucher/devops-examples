# Minimalist static website with AWS S3, CloudFormation & Route 53

CloudFormation stack to deploy a static website using a custom domain name with AWS S3 & Route 53. Our stack will contain:

- An S3 bucket holding our website content with a public access policy
  - The bucket will act as storage for our website data (HTML, CSS, etc.), we'll just need to copy our website content into it.   
- A Route 53 DNS record for our domain name pointing to our S3 bucket

Requirements:
- An existing Route53 Hosted Zone for our domain name
- An AWS user with enough permission to manage our stack (see [`iam-policy.json`](./iam-policy.json) for an example)

# Usage

Deploy the stack:

```sh
# Deploy our stack using given Hosted Zone and domain name
aws cloudformation deploy \
  --template-file cloudformation.yml \
  --stack-name minimalist-s3-website \
  --parameter-overrides \
    HostedZoneName='devops.crafteo.io.' \
    WebsiteFQDN='minimalist-s3-website.devops.crafteo.io'
```

Copy website content:

```
aws s3 sync --delete website/ s3://minimalist-s3-website.devops.crafteo.io
```

Enjoy: [`http://minimalist-s3-website.devops.crafteo.io`](http://minimalist-s3-website.devops.crafteo.io)

Cleanup:

```sh
# Delete CloudFormation stack
# S3 bucket won't be deleted - AWS won't allow it if bucket is not empty
# Bucket must be destroyed manually afterward (or emptied before deletion)
aws cloudformation delete-stack --stack-name minimalist-s3-website

# Force bucket deletion afterward
aws s3 rb --force s3://minimalist-s3-website.devops.crafteo.io
```