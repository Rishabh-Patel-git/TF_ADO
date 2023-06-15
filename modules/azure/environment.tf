resource "azuredevops_environment" "development_env" {
  project_id = azuredevops_project.tf_project.id
  name       = "Development"
}

resource "azuredevops_environment" "testing_env" {
  project_id = azuredevops_project.tf_project.id
  name       = "Testing"
}

resource "azuredevops_environment" "staging_env" {
  project_id = azuredevops_project.tf_project.id
  name       = "Staging"
}

resource "azuredevops_environment" "production_env" {
  project_id = azuredevops_project.tf_project.id
  name       = "Production"
}