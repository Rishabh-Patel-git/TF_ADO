terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.5.0"
    }
  }
}

# creating a project
resource "azuredevops_project" "tf_project" {
  name               = var.project_config.project_name
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  description        = var.project_config.proj_description
  features = {
    "artifacts" = "disabled"
  }
}

# Project level pipeline settings (limitation - organization lvl can override this)
resource "azuredevops_project_pipeline_settings" "pipeline_settings" {
  project_id = azuredevops_project.tf_project.id

  #Limit job authorization scope to current project for non-release pipelines
  enforce_job_scope = true

  #Protect access to repositories in YAML pipelines
  enforce_referenced_repo_scoped_token = true

  #Limit variables that can be set at queue time
  enforce_settable_var = true

  #Publish metadata from pipelines
  publish_pipeline_metadata = true

  #Disable anonymous access to badges
  status_badges_are_private = true
}


