select
    to_date(cast(event_date as varchar), 'YYYYMMDD') as event_date,
    event_timestamp,
    transaction_id,
    user_pseudo_id,
    cast(item_id as varchar) as item_id,
    item_name,
    item_category,
    quantity,
    item_revenue,
    purchase_revenue
from {{ source('raw', 'FACT_PURCHASES_SOURCE') }}