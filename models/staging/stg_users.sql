select
    user_pseudo_id,
    country,
    region,
    city,
    device_category,
    operating_system
from {{ source('raw', 'DIM_USERS_SOURCE') }}