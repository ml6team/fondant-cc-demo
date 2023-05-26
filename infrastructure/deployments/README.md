# Deploying standalone KFP pipelines on top of the cluster

## Deploying KFP pipeline

[kubeflow pipelines documentation](https://www.kubeflow.org/docs/components/pipelines/installation/standalone-deployment/#disable-the-public-endpoint)

[kubeflow pipelines github](https://github.com/kubeflow/pipelines/tree/0.5.1)


The documentation instructs you to deploy kubeflow pipelines on a GKE cluster, we've already deployed the cluster with terraform.

Make sure you are authenticated to the GKE cluster hosting KFP 
```commandline
gcloud container clusters get-credentials fondant-cluster --zone=europe-west4-a
```

## Customizing GCS and Cloud SQL for Artefact, Pipeline and Metadata storage

[GCP services setup](https://github.com/kubeflow/pipelines/tree/master/manifests/kustomize/sample)

We will setup `GCS` to store artefact and pipeline specs. This is done by deploying the `minio-gcs gateway` service.
We will also use `CloudSQL` to store all the ML metadata associated with our pipeline runs. This will guarantee that you are
able to retrieve metadata (experiments outputs, lineage visualization, ...) from our previous pipeline runs in case the GKE cluster where KFP is deployed get deleted.


First clone the [Kubeflow Pipelines GitHub repository](https://github.com/kubeflow/pipelines), and use it as your working directory.

```commandline
git clone https://github.com/kubeflow/pipelines
```

Next, we will need to customize our own values in the deployment manifest before deploying the additional services.  

**Note**: You will need the `CloudSQL` user root password that was created in the terraform setup. In your GCP project, go to
`Secret Manager` and retrieve the `sql-key` password that was stored there. 

### Customize values

Make sure to modify the following files:  

* `manifests/kustomize/env/gcp/params.env`  

```bash
pipelineDb=pipelinedb
mlmdDb=metadb
cacheDb=cachedb
bucketName=<PROJECT_ID>-kfp-artifacts #bucket to store the artifacts and pipeline specs (created in TF)
gcsProjectId=<PROJECT_ID # GCP project ID
gcsCloudSqlInstanceName=<PROJECT_ID>:<DB_REGION>:kfp-metadata # Metadata db (created in TF)
```

 `manifests/kustomize/base/installs/generic/mysql-secret.yaml`


  
Specify the `root` user password retrieved from `Secret Manager` in the designated fields. Make sure **you do not commit** the secret to your git history.

### Applying the customized resources

After specifying the required parameters, you can now install the additional services:

```commandline
kubectl apply -k manifests/kustomize/cluster-scoped-resources
kubectl wait crd/applications.app.k8s.io --for condition=established --timeout=60s
kubectl apply -k manifests/kustomize/env/gcp
```

The process of deploying the GCP resources may take from 3-5 minutes, you can check that status of the 
newly deployed services: 
```commandline
kubectl -n kubeflow get pods
```

## Installing GPU drivers 

Next, we need to install the GPU drivers on the GPU node pools to use them in KFP.
To install the GPU nodes, you have to manually scale up the GPU
pool from 0 to 1 to ensure that the installation takes effect (More on this issue [here](https://github.com/kubeflow/pipelines/issues/2561).).    

After that, apply:

```kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml```

After installing the drivers, you can set the pool back to 0. The pool can scale
up back again when called in the pipeline steps since autoscaling is enabled.

## Installing the Spark operator (Optional)
An additional installation is required to setup the [K8 operator for Spark](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator#installation).

```commandline
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
helm install my-release spark-operator/spark-operator --namespace kubeflow 
```
This will install the Kubernetes Operator for Apache Spark into the namespace `kubeflow`.
The operator by default watches and handles SparkApplications in every namespaces. 

## Deleting the KFP services
Run the following commands to delete the deployed KFP services from your GKE cluster. 


```commandline
kubectl delete -k manifests/kustomize/cluster-scoped-resources
kubectl delete -k manifests/kustomize/env/gcp
```

## Accessing KFP pipeline
There are three ways to connect to KFP UI, first make sure you autheticate to the GKE cluster hosting KFP:    

**1) Port-forwarding to access the kubernetes service**
```commandline
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80
```

Open the Kubeflow Pipelines UI at http://localhost:8080  

**2) Using the IAP URL of KFP**
```commandline
kubectl describe configmap inverse-proxy-config -n kubeflow | grep googleusercontent.com
```

**3) AI platform**

Alternatively, you can visualize your pipeline from the AI platform UI in the `pipelines` section.

