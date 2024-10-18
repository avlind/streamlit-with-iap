# Streamlit behind IAP: Header Inspection Demo
- A simple streamlit application, that is deployed out to Cloud Run two times, once as a public url, and the other with limited ingress to GCP Load Balancers, with the idea that it would be placed behind IAP.
- Streamlit app displays HTTP headers and cookies, and looks for headers specifically from Google Cloud IAP.
- Streamlit app also inspects both the plaintext headers as well as the signed jwt header. 
    - More information on inspecting the signed headers can be found [here](https://cloud.google.com/iap/docs/signed-headers-howto).

## Setting up your local terminal/command line for deployment
- In your IDE terminal, log into GCP Interactively using the gcloud cli with your Project Owner Identity and update gcloud cli to include beta functions
```
gcloud auth login
gcloud components install beta
gcloud config set project <<YOUR_PROJECT_ID>>
```

## Project Configuration
- Edit the `project_setup.sh` file and update the `_GCP_PROJECT` variable with your specific project ID.
- Execute `project_setup.sh` to configure a  project to host Cloud Run behind IAP. Script configures permissions, enabled APIs etc. 

## Deploy Cloud Run
- Edit the `deploy.sh` file and update the `_GCP_PROJECT` variable with your specific project ID.
- Execute `deploy.sh` to configure deploy the source code to Cloud Run. The script uses Cloud Build to build the Docker container, and deploy both a public version fo the app (allows all ingress) as well as a version of the app that is meant to sit behind a Google External Load Balancer and IAP.

## Configure IAP
- Review documentation and steps to configure IAP and a Google Load Balancer with Serverless NEG backend per the Official GCP Documentation. Some helpful links may be:
    - https://cloud.google.com/iap/docs/enabling-cloud-run
    - https://cloud.google.com/load-balancing/docs/https/setting-up-https-serverless
    - https://cloud.google.com/load-balancing/docs/serverless-neg