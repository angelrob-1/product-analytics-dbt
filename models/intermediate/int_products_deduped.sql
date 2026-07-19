with ranked_products as (

    select
        item_id,
        item_name,
        item_brand,
        item_category,
        price,
        row_number() over (
            partition by item_id
            order by length(item_category) desc nulls last
        ) as rn
    from {{ ref('stg_products') }}

)

select
    item_id,
    item_name,
    item_brand,
    item_category,
    price
from ranked_products
where rn = 1