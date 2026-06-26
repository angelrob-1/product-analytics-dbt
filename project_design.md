# Project Design

## Project Overview

This project uses GA4 ecommerce event data to build an analytics engineering workflow in Snowflake and dbt. The goal is to model user behavior, conversion funnels, customer retention, and product performance using dimensional modeling principles.

---

## Source Data

Source: BigQuery Public Dataset

Dataset:
ga4_obfuscated_sample_ecommerce

Key Events:
- page_view
- session_start
- view_item
- add_to_cart
- begin_checkout
- add_shipping_info
- add_payment_info
- purchase

Key Metrics:
- Purchase Revenue
- Item Revenue
- Quantity
- Sessions

---

## Business Questions

1. How efficiently do users move through the purchase funnel?
2. Which products generate the most revenue?
3. Which traffic sources generate the highest conversion rates?
4. What does customer retention look like over time?
