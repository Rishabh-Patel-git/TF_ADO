locals {
  parsed_json_config = jsondecode(file("${path.module}/project.json"))
}

# Adding an agent pool (It is at the org level, so it only needs to be added once)
resource "azuredevops_agent_pool" "tf_self_pool" {
  name           = "tf_self_pool"
  auto_provision = false
  auto_update    = false
  pool_type      = "automation"
}

# Creating multiple projects
module "azure_projects" {
  source         = "./modules/azure"
  count          = length(local.parsed_json_config.projects)
  project_config = local.parsed_json_config.projects[count.index]
  agent_pool_id  = azuredevops_agent_pool.tf_self_pool.id
}
