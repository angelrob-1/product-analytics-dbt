select
    cast(item_id as varchar) as item_id,
    item_name,
    item_brand,
    item_category,
    price
from {{ source('raw', 'DIM_PRODUCTS_SOURCE') }}