# All comments should be resolved before completion of Pull request
resource "azuredevops_branch_policy_comment_resolution" "comment_resolution_policy" {
  project_id = azuredevops_project.tf_project.id

  enabled  = true
  blocking = true

  settings {

    scope {
      repository_id  = azuredevops_git_repository.water_repo.id
      repository_ref = azuredevops_git_repository.water_repo.default_branch
      match_type     = "Exact"
    }
  }
}

# Requries a certain number of reviewers before completion of pull request
resource "azuredevops_branch_policy_min_reviewers" "reviewer_policy" {
  project_id = azuredevops_project.tf_project.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count                         = 5
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true # OR on_push_reset_all_votes = true
    on_last_iteration_require_vote         = false

    scope {
      repository_id  = azuredevops_git_repository.water_repo.id
      repository_ref = azuredevops_git_repository.water_repo.default_branch
      match_type     = "Exact"
    }
  }
}

# Encourage traceability by checking for linked work items on pull requests 
resource "azuredevops_branch_policy_work_item_linking" "work_item_policy" {
  project_id = azuredevops_project.tf_project.id
  enabled    = true
  blocking   = true

  settings {

    scope {
      repository_id  = azuredevops_git_repository.water_repo.id
      repository_ref = azuredevops_git_repository.water_repo.default_branch
      match_type     = "Exact"
    }
  }
}

# protecting environment so only main branch can deploy to it
resource "azuredevops_check_branch_control" "env_protect" {
  project_id           = azuredevops_project.tf_project.id
  display_name         = "Only main branch can deploy to environments"
  target_resource_id   = azuredevops_environment.development_env.id
  target_resource_type = "environment"
  allowed_branches     = "refs/heads/main"
}