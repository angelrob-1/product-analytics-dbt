with purchases as (

    select
        transaction_id,
        user_pseudo_id,
        event_date,
        event_timestamp,
        item_id,
        quantity,
        item_revenue,
        purchase_revenue
    from {{ ref('stg_purchases') }}

),

products as (

    select
        item_id,
        item_name,
        item_brand,
        item_category,
        price
    from {{ ref('int_products_deduped') }}

)

select
    purchases.transaction_id,
    purchases.user_pseudo_id,
    purchases.event_date,
    purchases.event_timestamp,
    purchases.item_id,
    products.item_name,
    products.item_brand,
    products.item_category,
    purchases.quantity,
    purchases.item_revenue,
    purchases.purchase_revenue,
    products.price
from purchases
left join products
    on purchases.item_id = products.item_id