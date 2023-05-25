# README for cluster.tf

## Workload identities

Using workload identities is the new recommended way to authenticate GKE pods with google service accounts. To do this, `cluster.tf` includes all the required boilerplate code that maps google service accounts to kubernetes service accounts. This is all you need to start using workload identities.

## Configure your service accounts in Terraform

In `cluster.tf` you will find a variable `service_accounts`. By updating this variable you can configure one or more service accounts. They will automatically be created and initialized to work with workload identities. By default we create a simple service account `primary-pod-sa` without any permissions.

## Assigning the service account to pods

By default, pods in a GKE cluster will not use the service account specified here.
Update the yaml definition of the deployment to assign a service account:
```
spec:
  serviceAccountName: KSA_NAME
```

Note that the name should be the name of the kubernetes service account that is linked to the google service account. If you are unsure of the name run `kubectl get serviceaccounts` to list all available kubernetes service accounts.

## Relevant documentation
https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to
