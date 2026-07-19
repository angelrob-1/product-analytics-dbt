select
    item_id,
    item_name,
    item_brand,
    item_category,

    sum(quantity) as total_quantity_sold,
    sum(item_revenue) as total_item_revenue,
    count(distinct transaction_id) as total_transactions,
    min(event_date) as first_purchase_date,
    max(event_date) as last_purchase_date,
    avg(price) as average_product_price

from {{ ref('int_product_sales') }}

group by
    item_id,
    item_name,
    item_brand,
    item_category