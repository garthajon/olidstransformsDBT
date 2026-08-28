{{ 
    config(
            materialized="table",

            tags=["location"]
    ) 
}}

with source as (
    select
        distinct
            postcode
    from {{ source('olids_common', 'ORGANISATION') }}
    where (LDS_IS_DELETED is null or LDS_IS_DELETED = false)
        and postcode is not null
)
select  
    row_number() over (order by postcode) as location_id,
    cast(null as varchar(50)) as address_1,
    cast(null as varchar(50)) as address_2,
    cast(null as varchar(50)) as city,
    cast(null as varchar(2)) as state,
    postcode as zip,
    cast(null as varchar(20)) as county,
    postcode as location_source_value,
    42035286 as country_concept_id,
    'United Kingdom' as country_source_value,
    cast(null as float) as latitude,
    cast(null as float) as longitude,
    'organisation' as source_table
from source