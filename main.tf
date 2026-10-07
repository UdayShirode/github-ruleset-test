resource "github_repository_ruleset" "main_branch_protection" {
  name        = "Protect Main Branch TF"
  repository  = var.repository_name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = var.key_id
    actor_type  = "DeployKey"
    bypass_mode = "always"
  }

  rules {

    # Block force push
    non_fast_forward = true

    # Prevent branch deletion
    deletion = true

    # Require linear history
    required_linear_history = true

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true
    }
  }
}
