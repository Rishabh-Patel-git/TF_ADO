
# Service connection for Jfrog artifactory
resource "azuredevops_serviceendpoint_jfrog_artifactory_v2" "artifactory_service" {
  project_id            = azuredevops_project.tf_project.id
  service_endpoint_name = "Jfrog Artifactory TF"
  description           = "Artifactory service created with terraform"
  url                   = var.project_config.artifactory_url
  authentication_token {
    token = var.project_config.artifactory_token
  }
}

# Service connection for sonarqube
resource "azuredevops_serviceendpoint_sonarqube" "sonar_service" {
  project_id            = azuredevops_project.tf_project.id
  service_endpoint_name = "SonarQube TF"
  url                   = var.project_config.sonar_url
  token                 = var.project_config.sonar_token
  description           = "SonarQube Service created with terraform"
}

# Service connection for docker hub
resource "azuredevops_serviceendpoint_dockerregistry" "docker_hub_service" {
  project_id            = azuredevops_project.tf_project.id
  service_endpoint_name = "Docker Hub TF"
  docker_username       = var.project_config.docker_hub_username
  docker_email          = var.project_config.docker_hub_email
  docker_password       = var.project_config.docker_hub_password
  registry_type         = "DockerHub"
}