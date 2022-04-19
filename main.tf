terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "<= 3.49"
    }
  }
}

resource "google_service_account" "helloworld" {
  account_id  = var.project
  description = "Service account used for terraform script"
}

resource "google_project_iam_member" "helloworld-roles" {
  count  = length(var.rolesList)
  role   = var.rolesList[count.index]
  member = "serviceAccount:${google_service_account.helloworld.email}"
}

module "appengine_app" {
  source        = "../helloworld_modules"
  project       = var.project
  location_id   = var.location_id
  database_type = var.database_type
}

# Enable the necessary services on the project for AppEngine deployments
resource "google_project_service" "service" {
  for_each                   = toset(var.gcp_service_list)
  project                    = var.project
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}



resource "google_app_engine_flexible_app_version" "myapp_v1" {
  version_id = "py8888"
  project = var.project
  service = "compute.googleapis.com"
  runtime = "python"

  entrypoint {
    shell = "python3 ./main.py"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path = "/"
  }

  env_variables = {
    port = "8080"
  }

  handlers {
    url_regex        = ".*\\/my-path\\/*"
    security_level   = "SECURE_ALWAYS"
    login            = "LOGIN_REQUIRED"
    auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT"

    static_files {
      path              = "my-other-path"
      upload_path_regex = ".*\\/my-path\\/*"
    }
  }

  automatic_scaling {
    cool_down_period = "120s"
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  noop_on_destroy = true
}

resource "google_storage_bucket" "bucket" {
  project  = var.project
  name     = "helloworld_2022"
  location = var.location_id
}

resource "google_storage_bucket_object" "object" {
  name   = "hello_world.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./hello_world.zip"
}
