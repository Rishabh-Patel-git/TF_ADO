## Add entitlements to all users from the AAD it-sales-team
module "add-entitlement-to-sales-team-group-users" {
  source           = "./modules/add-entitlement-to-group-users"
  aad_users_groups = var.project_config.developers
  license_type     = "basic"
}

## Add entitlements to all users from the AAD it-managers-team
module "add-entitlement-to-managers-team-group-users" {
  source           = "./modules/add-entitlement-to-group-users"
  aad_users_groups = var.project_config.managers
  license_type     = "stakeholder"
}

## Add the developer teams AAD group as contributor on the water team project
module "add-comm-group-to-azdo-sec-group" {
  source           = "./modules/add-aad-groups-to-azdo-team-project-sec-group"
  project_name     = azuredevops_project.tf_project.name
  azdo_group_name  = "Contributors"
  aad_users_groups = var.project_config.developers
  project_id       = azuredevops_project.tf_project.id

}

## Add the managers AAD group as readers on the commercial team project
module "add-manager-group-to-comm-azdo-sec-group" {
  source           = "./modules/add-aad-groups-to-azdo-team-project-sec-group"
  project_name     = azuredevops_project.tf_project.name
  azdo_group_name  = "Readers"
  aad_users_groups = var.project_config.managers
  project_id       = azuredevops_project.tf_project.id
}
