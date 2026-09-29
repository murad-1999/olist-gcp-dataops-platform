resource "google_billing_budget" "zero_cost_budget" {
  billing_account = var.billing_account_id
  display_name    = var.display_name

  budget_filter {
    projects               = ["projects/${var.project_id}"]
    credit_types_treatment = "INCLUDE_ALL_CREDITS"
  }

  amount {
    specified_amount {
      currency_code = var.currency_code
      units         = 0
      nanos         = 10000000 # Exactly $0.01 threshold for zero-cost guardrail
    }
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_percents
    content {
      threshold_percent = threshold_rules.value
    }
  }
}
