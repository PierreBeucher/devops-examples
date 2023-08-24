import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const awsIdPromise = aws.getCallerIdentity({});

awsIdPromise.then(awsId => {
    pulumi.log.info(`Deploying via IAM Role ${awsId.arn}`)
})