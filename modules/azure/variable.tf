variable "project_config" {
  description = "JSON configuration for Azure DevOps project"
  type        = object({
    project_name        = string
    repo_name           = string
    proj_description    = string
    emails_patterns     = list(string)
    sonar_token         = string
    sonar_url           = string
    artifactory_url     = string
    artifactory_token   = string
    docker_hub_email    = string
    docker_hub_password = string
    docker_hub_username = string
    developers          = list(string)
    managers            = list(string)
  })
}

variable "agent_pool_id"{
  type = string
}





