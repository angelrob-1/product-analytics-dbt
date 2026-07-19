# Product Analytics Engineering Pipeline | dbt + Snowflake

![dbt](https://img.shields.io/badge/dbt-Built-success)
![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-blue)
![SQL](https://img.shields.io/badge/SQL-Analytics%20Engineering-green)

## Overview

This project transforms raw Google Analytics 4 (GA4) ecommerce data into a business-ready **Product Performance Mart** using **Snowflake**, **dbt**, and **SQL**.

The project follows modern analytics engineering best practices by organizing transformations into staging, intermediate, and mart layers while incorporating automated testing, documentation, and version control.

---

## Business Problem

Business stakeholders need an efficient way to answer questions such as:

- Which products generate the most revenue?
- Which products sell the highest quantity?
- How many transactions has each product appeared in?
- When was a product first and last purchased?

Rather than querying raw ecommerce event data, this project creates a reusable analytics model that provides these metrics in a clean, business-friendly format.

---

## Dataset

This project uses the **Google Analytics 4 (GA4) Ecommerce public dataset**.

Due to BigQuery Sandbox export limitations, a representative subset of GA4 event-level data was exported and loaded into Snowflake for modeling. Product, user, and purchase source tables were fully loaded to support the analytics workflow.

---

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **BigQuery** | Source GA4 Ecommerce dataset |
| **Snowflake** | Cloud data warehouse |
| **dbt Fusion** | Data transformation and modeling |
| **SQL** | Data modeling |
| **Git** | Version control |
| **GitHub** | Repository hosting and collaboration |

---

## Project Architecture

```
RAW
│
├── DIM_PRODUCTS_SOURCE
├── DIM_USERS_SOURCE
└── FACT_PURCHASES_SOURCE
        │
        ▼
STAGING
├── stg_products
├── stg_users
└── stg_purchases
        │
        ▼
INTERMEDIATE
├── int_products_deduped
└── int_product_sales
        │
        ▼
MART
└── mart_product_performance
```

## dbt Lineage

![dbt Lineage](images/dbt-lineage.png)

The lineage graph illustrates how raw source tables flow through the staging, intermediate, and mart layers to produce the final Product Performance Mart.

---

## Data Modeling Approach

### Staging Layer

The staging layer standardizes raw source data while preserving its original business meaning.

Models:

- `stg_products`
- `stg_users`
- `stg_purchases`

Responsibilities include:

- Standardizing source data
- Selecting relevant fields
- Renaming columns
- Preparing data for downstream transformations

While `stg_users` is not used in the current Product Performance Mart, it was included to demonstrate staging of user data as part of a complete analytics engineering workflow.

---

### Intermediate Layer

The intermediate layer contains reusable business logic.

Models:

- `int_products_deduped`
- `int_product_sales`

Key transformations include:

- Deduplicating product records
- Joining purchase transactions with product attributes
- Creating reusable datasets for downstream analytics

---

### Mart Layer

The mart layer contains business-ready models for reporting and analysis.

Model:

- `mart_product_performance`

Key metrics include:

- Total revenue
- Total quantity sold
- Number of transactions
- Average product price
- First purchase date
- Last purchase date

---

## Data Quality & Documentation

This project implements automated data quality testing using dbt to ensure the integrity of the data pipeline.

### Built-in Tests

- `not_null`
- `unique`
- `relationships`

### Custom Test

- Ensures calculated product revenue values are never negative.

The project successfully passes a full:

```bash
dbt build
```

which builds all models and executes automated data quality tests to validate the pipeline end-to-end.

The project also includes comprehensive YAML documentation for models, columns, and data tests.

```bash
dbt docs generate
```

---

## Skills Demonstrated

- Analytics Engineering
- dbt Modeling
- Snowflake
- SQL
- Layered Data Modeling
- Data Warehousing
- Source-to-Mart Architecture
- Data Quality Testing
- YAML Documentation
- Git Feature Branch Workflow
- Pull Requests & Code Review

---

## Lessons Learned

Building this project reinforced core Analytics Engineering principles, including layered data modeling, modular SQL development, automated testing, documentation, and version control.

It also strengthened my understanding of designing reusable data models that are scalable, maintainable, and ready for downstream analytics and reporting.

---

## License

This project is intended for educational and portfolio purposes.
