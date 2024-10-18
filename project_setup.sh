#!/bin/bash

: <<'END'
################################################################################
Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
################################################################################
END

#You must update the _GCP_PROJECT variable with your project ID before running this script.
export _GCP_PROJECT="<<yourprojectid>>"

gcloud services enable run.googleapis.com \
serviceusage.googleapis.com \
cloudresourcemanager.googleapis.com \
cloudfunctions.googleapis.com \
cloudbuild.googleapis.com \
logging.googleapis.com \
compute.googleapis.com \
storage-api.googleapis.com \
beyondcorp.googleapis.com \
aiplatform.googleapis.com \
secretmanager.googleapis.com \
artifactregistry.googleapis.com \
iap.googleapis.com

PROJECT_NUMBER=$(gcloud projects describe "${_GCP_PROJECT}" --format='value(projectNumber)')
echo "Using project ID: ${_GCP_PROJECT}, project number: ${PROJECT_NUMBER}"

gcloud beta services identity create --service=iap.googleapis.com --project=${_GCP_PROJECT}

echo "Creating Artifact Registry Repository"
gcloud artifacts repositories create gcr.io --repository-format=docker --location=us 

echo "Grant CloudBuild running as Default Compute Service Acct access to deploy CloudRun"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
--role="roles/run.admin"

echo "Grant CloudBuild running as Default Compute Service Acct access to Storage Acct to retrieve source"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
--role="roles/storage.admin"

echo "Grant Cloud Build running as Default Compute access to push to Artifact Registry"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
--role="roles/artifactregistry.writer"

echo "Granting Default Service Acct Log Writer"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
--role="roles/logging.logWriter"

echo "Granting CloudRun invoker to IAP proxy.  This is important as IAP will not work without this step"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-iap.iam.gserviceaccount.com" \
--role="roles/run.invoker"

echo "Granting Service Account User to the default compute service account for the project"
gcloud projects add-iam-policy-binding "${_GCP_PROJECT}" \
--member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
--role="roles/iam.serviceAccountUser"
