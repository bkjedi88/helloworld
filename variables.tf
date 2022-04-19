# Variables for App Engine application
variable "location_id" {}
variable "database_type" {}
variable "project" {}
variable "billing_account" {}
variable "project_id" {}
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com"]
}
variable "rolesList" {}
