variable "project_name" {
    type = string
}

variable "azdo_group_name" {
    type = string
}

variable "aad_users_groups" {
    type = list(string)
    default = []
}

variable "project_id" {
  type = string
}


#/modules/add-aad-groups-to-azdo-team-project-sec-group/main.tf
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    
    azuread = {
      source = "azuread"
      version = ">=1.4.0"
    }
  }
}

## Get group info from azure ad
data "azuread_group" "aad_group" {
  for_each  = toset(var.aad_users_groups)
  display_name     = each.value
}

## Get group info from AzDo
data "azuredevops_group" "azdo_group" {
 # project_id = data.azuredevops_project.project.id
 project_id = var.project_id
  name       = var.azdo_group_name
}

## Link the aad group to an azdo group
resource "azuredevops_group" "azdo_group_linked_to_aad" {
  for_each  = toset(var.aad_users_groups)
  origin_id = data.azuread_group.aad_group[each.key].object_id
}

## Add membership
resource "azuredevops_group_membership" "membership" {
  group = data.azuredevops_group.azdo_group.descriptor
  members = flatten(values(azuredevops_group.azdo_group_linked_to_aad)[*].descriptor)
}