select *
from {{ ref('mart_product_performance') }}
where total_item_revenue < 0