output "budget_id" {
  description = "The resource identifier of the billing budget."
  value       = google_billing_budget.zero_cost_budget.id
}

output "budget_name" {
  description = "The resource name of the billing budget."
  value       = google_billing_budget.zero_cost_budget.name
}
