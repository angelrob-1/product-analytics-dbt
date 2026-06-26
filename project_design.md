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

## Table Grains

### FACT_EVENTS

Grain:
One row per user event.

### FACT_PURCHASES

Grain:
One row per purchased item.

### DIM_USERS

Grain:
One row per unique user.

### DIM_PRODUCTS

Grain:
One row per unique product.

### DIM_DATES

Grain:
One row per calendar date.

## Star Schema

This project uses a star schema to organize ecommerce product analytics data for reporting and analysis. Fact tables store measurable user actions and purchase activity, while dimension tables provide descriptive context about users, products, and dates.

### Star Schema Design

```text
                    DIM_USERS
                        |
                        |
                    FACT_EVENTS
                        |
                        |
                    DIM_DATES


DIM_USERS ----- FACT_PURCHASES ----- DIM_PRODUCTS
                        |
                        |
                    DIM_DATES
```

### Fact-to-Dimension Relationships

#### FACT_EVENTS

Connected dimensions:

- DIM_USERS
- DIM_DATES

Purpose:

FACT_EVENTS stores user behavior events such as page views, product views, add-to-cart actions, checkout starts, and purchases.

#### FACT_PURCHASES

Connected dimensions:

- DIM_USERS
- DIM_PRODUCTS
- DIM_DATES

Purpose:

FACT_PURCHASES stores item-level purchase activity, including transaction ID, product ID, quantity, and revenue.

### Why a Star Schema

A star schema was selected because the goal of this project is analytics and reporting. Keeping dimensions directly connected to fact tables makes the model easier to query, easier to document, and easier to use for dashboards and business analysis.

## Fact Tables

### FACT_EVENTS

Purpose:
Stores user behavior events used for funnel and engagement analysis.

Grain:
One row per user event.

Key Fields:
- event_id
- user_id
- event_name
- event_timestamp
- event_date
- session_id
- traffic_source
- device_category
- country

Used For:
- Conversion funnel analysis
- User behavior analysis
- Traffic source performance
- Event volume trends

---

### FACT_PURCHASES

Purpose:
Stores item-level purchase activity used for revenue and product performance analysis.

Grain:
One row per purchased item.

Key Fields:
- transaction_id
- user_id
- product_id
- purchase_date
- quantity
- item_revenue
- purchase_revenue

Used For:
- Product revenue analysis
- Customer lifetime value
- Average order value
- Repeat purchase analysis

## Dimension Tables

### DIM_USERS

Purpose:
Stores descriptive information about users to support behavioral, conversion, and retention analysis.

Grain:
One row per unique user.

Key Fields:
- user_id
- first_visit_date
- country
- region
- city
- device_category
- operating_system

Used For:
- User segmentation
- Geographic analysis
- Device performance analysis
- Retention analysis

---

### DIM_PRODUCTS

Purpose:
Stores descriptive information about products to support product performance and revenue analysis.

Grain:
One row per unique product.

Key Fields:
- product_id
- product_name
- brand
- category
- price

Used For:
- Product performance analysis
- Revenue analysis
- Category analysis
- Product conversion analysis

---

### DIM_DATES

Purpose:
Stores calendar attributes used for time-based reporting and trend analysis.

Grain:
One row per calendar date.

Key Fields:
- date
- day_of_week
- week
- month
- quarter
- year

Used For:
- Time-series analysis
- Monthly reporting
- Quarterly reporting
- Cohort analysis

## Analytics Marts

### MART_CONVERSION_FUNNEL

Purpose:
Summarizes how users move through the ecommerce purchase funnel.

Grain:
One row per funnel step.

Funnel Steps:
- session_start
- view_item
- add_to_cart
- begin_checkout
- purchase

Key Metrics:
- users_at_step
- step_conversion_rate
- overall_conversion_rate

Business Question:
How efficiently do users move through the purchase funnel?

---

### MART_COHORT_RETENTION

Purpose:
Tracks whether users return after their first visit.

Grain:
One row per cohort month and activity month.

Key Metrics:
- cohort_month
- activity_month
- active_users
- retained_users
- retention_rate

Business Question:
What does customer retention look like over time?

---

### MART_PRODUCT_PERFORMANCE

Purpose:
Summarizes product-level revenue and purchase performance.

Grain:
One row per product.

Key Metrics:
- product_id
- product_name
- category
- total_quantity_sold
- total_revenue
- purchase_count

Business Question:
Which products generate the most revenue?

---

### MART_TRAFFIC_SOURCE_PERFORMANCE

Purpose:
Summarizes acquisition channel performance across user behavior and purchases.

Grain:
One row per traffic source.

Key Metrics:
- traffic_source
- sessions
- users
- purchases
- revenue
- conversion_rate

Business Question:
Which traffic sources generate the highest conversion rates?

## Data Quality Tests

This project will use dbt tests to validate data quality and ensure the final models are reliable for analysis.

### FACT_EVENTS Tests

- event_id should be unique
- event_id should not be null
- user_id should not be null
- event_name should not be null
- event_name should be one of the expected GA4 ecommerce events
- event_date should not be null

### FACT_PURCHASES Tests

- transaction_id should not be null
- product_id should not be null
- user_id should not be null
- quantity should be greater than 0
- item_revenue should be greater than or equal to 0

### DIM_USERS Tests

- user_id should be unique
- user_id should not be null

### DIM_PRODUCTS Tests

- product_id should be unique
- product_id should not be null
- product_name should not be null

### DIM_DATES Tests

- date should be unique
- date should not be null

### Relationship Tests

- FACT_EVENTS.user_id should exist in DIM_USERS
- FACT_EVENTS.event_date should exist in DIM_DATES
- FACT_PURCHASES.user_id should exist in DIM_USERS
- FACT_PURCHASES.product_id should exist in DIM_PRODUCTS
- FACT_PURCHASES.purchase_date should exist in DIM_DATES

## dbt Architecture

This project follows a layered dbt architecture to transform raw ecommerce event data into analytics-ready fact tables, dimension tables, and business marts.

### Architecture Flow

RAW
↓
STAGING
↓
INTERMEDIATE
↓
MARTS

---

### RAW Layer

Purpose:

Stores source data loaded from the GA4 Ecommerce public dataset.

Tables:

- RAW.EVENTS

Responsibilities:

- No transformations
- Preserve source data structure
- Serve as the ingestion layer

---

### STAGING Layer

Purpose:

Standardize source data and prepare it for modeling.

Models:

- STG_EVENTS
- STG_PRODUCTS
- STG_USERS
- STG_PURCHASES

Responsibilities:

- Rename columns
- Standardize data types
- Handle null values
- Flatten nested GA4 structures
- Apply basic data cleaning

---

### INTERMEDIATE Layer

Purpose:

Apply business logic and create reusable transformations.

Models:

- INT_USER_SESSIONS
- INT_FUNNEL_STEPS
- INT_PRODUCT_EVENTS
- INT_PURCHASE_EVENTS

Responsibilities:

- Session calculations
- Funnel step identification
- User behavior transformations
- Product event aggregation

---

### MARTS Layer

Purpose:

Create business-facing datasets for reporting and analytics.

Fact Tables:

- FACT_EVENTS
- FACT_PURCHASES

Dimension Tables:

- DIM_USERS
- DIM_PRODUCTS
- DIM_DATES

Analytics Marts:

- MART_CONVERSION_FUNNEL
- MART_COHORT_RETENTION
- MART_PRODUCT_PERFORMANCE
- MART_TRAFFIC_SOURCE_PERFORMANCE

Responsibilities:

- Support business reporting
- Enable dashboard development
- Deliver analytics-ready datasets

---

### dbt Features

This project will utilize the following dbt capabilities:

- Model materializations
- Source definitions
- Schema tests
- Relationship tests
- Documentation generation
- Incremental models
- Model lineage tracking

## Project Roadmap

### Phase 1: Planning & Design
- Explore source data in BigQuery
- Define business questions
- Design star schema
- Define table grains
- Create project documentation

### Phase 2: Environment Setup
- Configure Snowflake environment
- Set up dbt project
- Connect dbt to Snowflake
- Create project repository structure

### Phase 3: Data Ingestion & Staging
- Load source data into RAW schema
- Build staging models
- Clean and standardize source data
- Flatten nested ecommerce event structures

### Phase 4: Core Data Modeling
- Build intermediate models
- Create dimension tables
- Create fact tables
- Implement dbt tests

### Phase 5: Analytics Layer
- Build analytics marts
- Create funnel analysis
- Create retention analysis
- Create product performance analysis
- Create traffic source analysis

### Phase 6: Documentation & Portfolio
- Generate dbt documentation
- Create project screenshots
- Complete GitHub README
- Document business findings
