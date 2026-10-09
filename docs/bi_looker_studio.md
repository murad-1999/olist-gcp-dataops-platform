# Looker Studio BI & Analytics Guide
## Olist Brazilian E-Commerce Executive Dashboard

This guide provides the complete blueprint for connecting **Google Looker Studio** to the `olist_gold` BigQuery layer, defining calculated business metrics, and assembling a 3-page executive reporting suite—engineered strictly to maintain **$0.00 query spend** under the GCP Always Free Tier.

---

## 1. Zero-Cost Query Optimization in Looker Studio

To ensure dashboard queries remain well within BigQuery's **1 TB/month free query tier**:

1. **Partition Pruning:** All Gold fact tables (`fact_orders`, `fact_order_items`, `fact_order_payments`, `fact_order_reviews`) are partitioned daily by `order_purchase_timestamp`. Always include a **Date Range Control** set to `order_purchase_timestamp` on every dashboard page to prune scanned partitions.
2. **Clustering Efficiency:** Tables are clustered by high-cardinality keys (`customer_id`, `product_id`, `seller_id`, `order_id`). Filtering or grouping by these columns significantly reduces data block scanning.
3. **Data Freshness / Caching:** Set Looker Studio data freshness to **12 hours** or **24 hours**. This ensures repeated dashboard views are served directly from the Looker Studio in-memory cache at zero BigQuery query cost.

---

## 2. BigQuery Data Sources Setup

In Google Looker Studio ([lookerstudio.google.com](https://lookerstudio.google.com/)):

1. Click **Create** > **Data Source**.
2. Select the **BigQuery** connector.
3. Choose **My Projects** > Select your GCP Project (e.g., `olist-dataops-73908`).
4. Select Dataset: `olist_gold`.

### Recommended Data Models

#### Model A: Order & Delivery Intelligence (`ds_orders_executive`)
* **Primary Table:** `fact_orders`
* **Left Join:** `dim_customers` on `fact_orders.customer_id = dim_customers.customer_id`

#### Model B: SKU, Merchandising & Seller Performance (`ds_order_items_merchandising`)
* **Primary Table:** `fact_order_items`
* **Left Join:** `dim_products` on `fact_order_items.product_id = dim_products.product_id`
* **Left Join:** `dim_sellers` on `fact_order_items.seller_id = dim_sellers.seller_id`
* **Left Join:** `dim_customers` on `fact_order_items.customer_id = dim_customers.customer_id`

#### Model C: Customer Experience & Reviews (`ds_order_reviews`)
* **Primary Table:** `fact_order_reviews`
* **Left Join:** `dim_customers` on `fact_order_reviews.customer_id = dim_customers.customer_id`

---

## 3. Calculated Metrics & Dimensions Formulas

Add these calculated fields directly inside your Looker Studio Data Sources:

### Financial & Sales Metrics
| Metric Name | Formula / Definition | Type |
| :--- | :--- | :--- |
| **Gross Merchandise Value (GMV)** | `SUM(price)` | Currency (BRL / USD) |
| **Total Order Items Value** | `SUM(total_order_items_value)` | Currency (BRL / USD) |
| **Total Freight Value** | `SUM(freight_value)` | Currency (BRL / USD) |
| **Average Order Value (AOV)** | `SUM(total_order_items_value) / COUNT_DISTINCT(order_id)` | Currency (BRL / USD) |
| **Freight-to-Price Ratio** | `SUM(freight_value) / SUM(price)` | Percent |
| **Items per Order** | `COUNT(order_item_key) / COUNT_DISTINCT(order_id)` | Numeric (1 decimal) |

### Logistics & SLA Adherence Metrics
| Metric Name | Formula / Definition | Type |
| :--- | :--- | :--- |
| **Actual Delivery Duration (Days)** | `DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp)` | Numeric |
| **Estimated Delivery Duration (Days)**| `DATE_DIFF(order_estimated_delivery_date, order_purchase_timestamp)` | Numeric |
| **Carrier Transit Duration (Days)** | `DATE_DIFF(order_delivered_customer_date, order_delivered_carrier_date)` | Numeric |
| **Delivery Delay vs Estimate (Days)**| `DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date)` | Numeric |
| **Delivery Status Flag** | `CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN "On Time" ELSE "Delayed" END` | Text |
| **On-Time Delivery Rate (%)** | `SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(order_id)` | Percent |

### Customer Experience & Sentiment Metrics
| Metric Name | Formula / Definition | Type |
| :--- | :--- | :--- |
| **Average CSAT / Review Score** | `AVG(review_score)` | Numeric (2 decimals) |
| **Positive Reviews (4-5 Stars)** | `SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END)` | Numeric |
| **Negative Reviews (1-2 Stars)** | `SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END)` | Numeric |
| **Net Customer Satisfaction Index** | `(SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) - SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END)) / COUNT(review_id)` | Percent |

---

## 4. Dashboard Architecture: 3-Page Blueprint

```
┌────────────────────────────────────────────────────────────────────────┐
│                   Olist Executive BI Suite                             │
├────────────────────┬────────────────────┬──────────────────────────────┤
│ 1. Executive KPIs  │ 2. Logistics & SLA │ 3. Merchandising & Sellers   │
└────────────────────┴────────────────────┴──────────────────────────────┘
```

### Page 1: Executive KPI Command Center
* **Objective:** High-level executive pulse of top-line revenue, order volumes, customer distribution, and satisfaction.
* **Top Filters:** Date Range Control (`order_purchase_timestamp`), Order Status filter (`delivered`, `shipped`, `canceled`).
* **KPI Scorecards:**
  * Total GMV / Revenue
  * Total Orders Count
  * Average Order Value (AOV)
  * On-Time Delivery Rate (%)
  * Average Customer Review Rating
* **Charts:**
  * **Revenue & Volume Trend (Time Series):** Monthly GMV (Bars) overlayed with Order Volume (Line).
  * **Regional Sales Distribution (Geo Choropleth Map):** Brazil State map shaded by GMV with customer count in tooltip.
  * **Payment Method Breakdown (Donut Chart):** Share of orders by `payment_type` (Credit Card, Boleto, Voucher, Debit).
  * **Order Status Composition (Bar Chart):** Distribution of orders across lifecycle stages.

---

### Page 2: Logistics & Fulfillment Operations
* **Objective:** Monitor supply chain performance, carrier bottlenecks, delivery SLAs, and regional freight costs.
* **Top Filters:** Date Range, Customer State (`customer_state`), Seller State (`seller_state`).
* **KPI Scorecards:**
  * Average Delivery Time (Days)
  * Average Carrier Transit Time (Days)
  * Total Delayed Orders
  * Average Freight Value per Order
* **Charts:**
  * **Delivery SLA Adherence (Stacked Bar):** Monthly on-time vs. delayed delivery percentages.
  * **Delivery Duration by Customer State (Horizontal Bar):** Average delivery days ranked by destination state.
  * **State-to-State Transit Heatmap / Pivot Table:** Origin State (`seller_state`) vs Destination State (`customer_state`) measuring average delivery days.
  * **Freight Cost vs Delivery Speed (Scatter Plot):** Average freight value vs. average delivery duration across top Brazilian metro regions.

---

### Page 3: Merchandising, Products & Seller Insights
* **Objective:** Product category mix, seller concentration, inventory catalog depth, and customer sentiment drivers.
* **Top Filters:** Date Range, Product Category (`product_category_name_english`), Seller State.
* **KPI Scorecards:**
  * Active Selling Products Count
  * Active Merchants / Sellers Count
  * Average Items per Order
  * Total Freight Ratio (%)
* **Charts:**
  * **Top 10 Product Categories by Revenue (Horizontal Bar):** Category rankings using translated English names (`bed_bath_table`, `health_beauty`, `sports_leisure`, etc.).
  * **Category Share (Treemap):** Proportion of item sales volume across product categories.
  * **Top Performing Sellers (Table):** `seller_id`, `seller_state`, Item Volume, Total GMV, and Average Review Score.
  * **Review Score vs Product Specification (Scatter Plot):** Customer review score vs Product Photos Quantity or Product Description Length.

---

## 5. Free-Tier Compliance Checklist for BI

- [x] **No Full Table Scans:** Always enforce date range filters to utilize BigQuery partition pruning.
- [x] **BI Engine Acceleration:** If query latency is desired, Looker Studio connects natively to BigQuery without requiring custom SQL wrappers.
- [x] **Zero Egress:** Looker Studio and BigQuery both operate within Google's internal backbone, generating $0.00 data transfer charges.
- [x] **Pre-Aggregated Fact Tables:** Order totals and review scores are pre-aggregated in `fact_orders` and `fact_order_reviews`, eliminating expensive runtime table scans.
