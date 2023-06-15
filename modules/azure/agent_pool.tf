
# Making it visible to projects (In the UI, this is equivalent to adding an Organization defined pool to a project)
resource "azuredevops_agent_queue" "tf_agent_queue" {
  project_id    = azuredevops_project.tf_project.id
  agent_pool_id = var.agent_pool_id
}

# Grant access to queue to all pipelines in the project
resource "azuredevops_resource_authorization" "tf_agent_pool_auth" {
  project_id  = azuredevops_project.tf_project.id
  resource_id = var.agent_pool_id
  type        = "queue"
  authorized  = true
}
