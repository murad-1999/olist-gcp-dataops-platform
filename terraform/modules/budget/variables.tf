variable "billing_account_id" {
  description = "The ID of the GCP Billing Account to associate the budget with."
  type        = string
}

variable "project_id" {
  description = "The GCP Project ID to filter the budget alert."
  type        = string
}

variable "display_name" {
  description = "Display name for the billing budget alert."
  type        = string
  default     = "zero-cost-guardrail-budget"
}

variable "currency_code" {
  description = "Currency code for the budget alert."
  type        = string
  default     = "USD"
}

variable "threshold_percents" {
  description = "List of alert threshold percentages (e.g. 0.5, 0.9, 1.0)."
  type        = list(number)
  default     = [0.5, 0.9, 1.0]
}
