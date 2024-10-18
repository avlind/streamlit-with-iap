#!/bin/bash

: <<'END'
################################################################################
Copyright (C) 2024 Google LLC

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

###############################################################################
################ EDIT THIS SECTION BEFORE RUNNING THE SCRIPT ##################
# Globals

export _GCP_PROJECT="<<yourprojectid>>"

###############################################################################

# Set Default Project
echo "Setting Default Project"

# Get Default Project ID
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format='value(projectNumber)')
echo "Using project ID: ${PROJECT_ID}, project number: ${PROJECT_NUMBER}"

_IAP_AUDIENCE="/projects/${PROJECT_NUMBER}/global/backendServices/yourbackendserviceid"

# Build, push, and deploy the container image
echo "Building, pushing, and deploying the container image"
gcloud builds submit --region=us-central1 --config cloudbuild.yaml --substitutions="_IAP_AUDIENCE=${_IAP_AUDIENCE}"
echo "Done building, pushing, and deploying the container image"