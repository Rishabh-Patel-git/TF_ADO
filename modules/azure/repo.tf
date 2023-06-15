# Creating a repository 
resource "azuredevops_git_repository" "water_repo" {
  project_id     = azuredevops_project.tf_project.id
  name           = var.project_config.repo_name
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
}

# Creating a development branch to follow git workflow
resource "azuredevops_git_repository_branch" "dev_branch" {
  repository_id = azuredevops_git_repository.water_repo.id
  name          = "dev"
  ref_branch    = azuredevops_git_repository.water_repo.default_branch
}


# Repository policies:-

# Only recognized emails can push to repository
resource "azuredevops_repository_policy_author_email_pattern" "email_pattern" {
  project_id            = azuredevops_project.tf_project.id
  enabled               = true
  blocking              = true
  author_email_patterns = var.project_config.emails_patterns # Allowed patterns
}

# Block pushes that introduce files or branch names that include platform reserved names 
resource "azuredevops_repository_policy_reserved_names" "reserved_name_policy" {
  project_id     = azuredevops_project.tf_project.id
  enabled        = true
  blocking       = true
  repository_ids = [azuredevops_git_repository.water_repo.id]
}

# Avoid case-sensitivity conflicts by blocking pushes that change name casing on files etc
resource "azuredevops_repository_policy_case_enforcement" "case_enforce_policy" {
  project_id              = azuredevops_project.tf_project.id
  enabled                 = true
  blocking                = true
  enforce_consistent_case = true
}
