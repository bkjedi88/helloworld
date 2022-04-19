# Variables for App Engine application
location_id     = "us-east1"
database_type   = "CLOUD_FIRESTORE"
project         = "new-demo-347715"
billing_account = "$(gcloud beta billing accounts list --format=json | jq .[0].name -r | cut -d'/' -f2)"
project_id      = "457842895190"
#project_id      = "$(gcloud config list --format 'value(core.project)')"
rolesList = [
  "roles/iam.serviceAccountUser",
  # "roles/resourcemanager.projectCreator",
  "roles/appengine.appCreator",
  "roles/storage.objectAdmin",
  "roles/cloudbuild.builds.editor"
]
