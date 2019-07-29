---
layout: post
title: "Simple Custom Resources for the AWS CDK"
date: 2019-07-28 12:23:37 -0700
categories: tech
---

If you are using the [AWS CDK] you will quickly discover that because it's just a wrapper around CloudFormation, it shares
with it the issue that not all of AWS's features have been implemented.

Perhaps you need to enable Aurora's [Data API], which was the case for me. Whatever it is, you know you just need
to make a single AWS API call. What's the simplest thing for you to do?

## The not simple approach

Your story might go something like this:

1. You do some googling and learn from [StackOverflow] that you can do this with "Custom Resources", which the CDK supports
   with [CustomResource]
2. You find the [cfn-response] module which is supposed to abstract away the details of sending a response to CloudFormation
   to let it know the status of your resource after CloudFormation requests that is is created, updated or deleted.
3. You try numerous times to actually import it correctly in your Lambda function, which is difficult because:
   - The docs ask you use `ZipFile` but in the CDK you do that using `lambda.Code.inline`, _not_ by specifying a directory which
     will get zipped, which is not terribly obvious,
   - Every time you make a mistake, CloudFormation gets stuck rolling back because your custom resource is unable
     to respond to say that it has been successfully deleted,
   - You eventually discover that the `cfn-response` library doesn't work with a lambda function which uses `async` anyway,
     and you don't want to give up on `async` because it's ~the future~.
4. So you switch to using [cfn-response-promise]. Now you have to go back to `lambda.Code.asset` because you're installing a 3rd
   party library. Also, remember to return the result of `send` now or you'll still get stuck!
5. You learn the hard way that `CustomResource` parameter names are title-cased when they're passed to your lambda function.
6. You discover that you can't pass a reference to a `CfnDBSubnetGroup` via Custom REsource parameters using `.dbClusterIdentifier`, but `.ref` seems to work.
7. When you get through all of this it dawns on you that you still have to give your Lambda function permissions to do whatever it needs to do.

At this point you start to wonder whether there was a simpler way, poke around in the CDK docs and notice something sitting at the bottom... [custom-resources].

This library provides a Construct called `AwsCustomResource` which lets you specify a single SDK call which will happen when my resource is created, updated or deleted. Great! You throw something together:

```js
new AwsCustomResource(this, "ToggleDataAPI", {
  onCreate: {
    service: "RDS",
    action: "ModifyDBCluster",
    parameters: {
    DBClusterIdentifier: db.dbClusterIdentifier,
    EnableHttpEndpoint: true,
    physicalResourceId: `DbDataApiToggle`
  }
});
```

It looks like `cdk synth` is happy so you run `cdk deploy`.

    Failed to create resource. awsService[call.action] is not a function
        new CustomResource (.../node_modules/@aws-cdk/aws-cloudformation/lib/custom-resource.ts:92:21)
        \_ new AwsCustomResource (.../node_modules/@aws-cdk/custom-resources/lib/aws-custom-resource.ts:159:27)

Why is this happening? ModifyDBCluster perfectly matches the action name given in the [AWS Docs]. Perhaps the source
code will be enlightening. You find the reference to `awsService` in the source code for the [Lambda function] itself.

```ts
const awsService = new (AWS as any)[call.service](call.apiVersion && { apiVersion: call.apiVersion });

try {
    const response = await awsService[call.action](call.parameters && fixBooleans(call.parameters)).promise();
    // ...
```

This code is trying to look up the function you specified in the `aws-sdk` library but `ModifyDBCluster` doesn't
exist in `AWS.RDS`. So what does exist in `RDS`? Yep, **`modifyDBCluster`** with a small `m`.

Finally you `cdk deploy` and it works. You took 5 hours to successfully automate _a single button press_.

<div class="thumbnailed">
  <a href="/images/data_api.png">
    <img src="/images/data_api.png" alt="Data API: checked" />
  </a>
  Was it worth it?
</div>

## A better way

The `AwsCustomResource` class seems like it's almost a winner when all you need to do is make AWS API calls, but I did not go
through all of the above described effort just to live in a world where I discover configuration typos _deploy time_, so I
made a library called [checked-aws-custom-resource] which consists of a single resource which just wraps `AwsCustomResource`
and checks at compile time whether all specified actions exist. It's really pretty simple, but now I feel like I'll be able
to use the CDK to poke AWS APIs without fear.

It's basically a drop-in replacement:

```js
import { CheckedAwsCustomResource } from "checked-aws-custom-resource";

//...

new CheckedAwsCustomResource(this, "ToggleDataAPI", {
  onCreate: {
    service: "RDS",
    action: "ModifyDBCluster",
    parameters: {
    DBClusterIdentifier: db.dbClusterIdentifier,
    EnableHttpEndpoint: true,
    physicalResourceId: `DbDataApiToggle`
  }
});
```

its implementation is little more than to subclass `AwsCustomResource` and add this to the `constructor`:

```ts
if (typeof awsService[call.action] !== "function") {
  throw new Error(`${call.action} is not a function in AWS.${call.service}`);
}
```

and you can install it yourself with:

```
npm install checked-aws-custom-resource --save
```

## Thoughts

Overall, I have come away from this experience with a few thoughts:

1. CloudFormation (and AWS as a whole, really) is a minefield of gotchas,
2. If there are some simply documented basic best practices for CDK/CloudFormation/Infra-As-Code development out there, I would love to know more,
3. The CDK smooths over many of the edges, but also introduces a few.

To be fair to the CDK, it's mostly be a joy to use, and it's still experimental, but ultimately, **every
new layer of complexity creates an opportunity for bugs to hide and abstractions to leak.**

For example, take this [snippet] from the source code of `custom-resources`:

```ts
/**
 * Transform SDK service/action to IAM action using metadata from aws-sdk module.
 * Example: CloudWatchLogs with putRetentionPolicy => logs:PutRetentionPolicy
 *
 * TODO: is this mapping correct for all services?
 */
function awsSdkToIamAction(service: string, action: string): string {
  const srv = service.toLowerCase();
  const iamService = awsSdkMetadata[srv].prefix || srv;
  const iamAction = action.charAt(0).toUpperCase() + action.slice(1);
  return `${iamService}:${iamAction}`;
}
```

I don't know `TODO`, you tell me!

[aws cdk]: https://docs.aws.amazon.com/cdk/latest/guide/home.html
[data api]: https://aws.amazon.com/blogs/aws/new-data-api-for-amazon-aurora-serverless/
[stackoverflow]: https://stackoverflow.com/questions/54931548/enable-aurora-data-api-from-cloudformation
[cfn-response]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-lambda-function-code-cfnresponsemodule.html
[cfn-response-promise]: https://github.com/ispyinternet/cfn-response-promise
[custom-resources]: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_custom-resources.AwsCustomResource.html
[aws docs]: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_ModifyDBCluster.html
[lambda function]: https://github.com/aws/aws-cdk/blob/6c0bf4ac1b21116d94e26d740a0302f92207b3b1/packages/%40aws-cdk/custom-resources/lib/aws-custom-resource-provider/index.ts#L63
[checked-aws-custom-resource]: https://github.com/Spacerat/checked-aws-custom-resource
[snippet]: https://github.com/aws/aws-cdk/blob/6c0bf4ac1b21116d94e26d740a0302f92207b3b1/packages/%40aws-cdk/custom-resources/lib/aws-custom-resource.ts
[customresource]: https://docs.aws.amazon.com/cdk/api/latest/docs/@aws-cdk_aws-cloudformation.CustomResource.html
