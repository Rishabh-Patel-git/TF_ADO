#/modules//add-entitlement-to-group-users/variables.tf

variable "license_type" {
    type = string
}

variable "aad_users_groups" {
    type = list(string)
}


#/modules/add-entitlement-to-group-users/main.tf
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

## Flattening the members from the different groups
locals {
  members = distinct(flatten([
    for s in data.azuread_group.aad_group: [
      for m in s.members:{
        item = m
      }
    ]
  ]))
}

## Get group info from azure ad
data "azuread_group" "aad_group" {
  for_each  = toset(var.aad_users_groups)
  display_name     = each.value
}

## Get aad users from group
data "azuread_user" "aad_users" {
  for_each = { for x in local.members: x.item => x }
  object_id = each.value.item
}

## Add entitlement to users in the aad group
resource "azuredevops_user_entitlement" "user" {
  for_each = data.azuread_user.aad_users
  principal_name = each.value.user_principal_name
  account_license_type = var.license_type
}

#/modules/add-entitlement-to-group-users/output.tf
output "aad_users" {
    value = {
        for user in data.azuread_user.aad_users: 
            user.id => user.display_name
    }
}
