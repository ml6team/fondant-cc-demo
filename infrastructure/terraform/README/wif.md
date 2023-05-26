
# README for Workload Identity Federation

## Prerequisites

You need to have the following IAM roles to apply the terraform configuration:

- roles/iam.workloadIdentityPoolAdmin
- roles/iam.serviceAccountAdmin

## Usage

You can use Nimbus to generate the components required for workload identity federation via `nimbus gcp init`.

### Variables

Note: the default value for the `bitbucket_repo_ids` local in `wif.tf` is an empty list.
You have to update it with the UUID of the bitbucket repositories that should have
access!
You can find more info in the Bitbucket documentation linked at the end.

All other variables are set by Nimbus to use the ML6 Bitbucket workspace by default. If you need to connect a different 
workspace, you can check the descriptions of these variables in the generated `wif` module (`modules/wif/variables.tf`)

## Background information

If you want to learn more about the concepts behind workload identity federation, you can check out the following sources:

- [Chapter Conference Talk (April 2022)](https://docs.google.com/presentation/d/1liJi-QdurS1cJ2W57CYy0kbbSLx5GR8YlQPDJXcy3cw/edit?usp=sharing)
- [Google Documentation](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Bitbucket Documentation](https://support.atlassian.com/bitbucket-cloud/docs/integrate-pipelines-with-resource-servers-using-oidc/)
- Google Cloud blogposts: [1](https://cloud.google.com/blog/products/identity-security/enable-keyless-access-to-gcp-with-workload-identity-federation) and [2](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)

