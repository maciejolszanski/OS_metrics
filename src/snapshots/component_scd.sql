{% snapshot component_scd %}

{{
    config(
      unique_key="host || '_' || component_id",
      strategy='timestamp',
      updated_at='timestamp'
    )
}}


select * from {{ ref('bronze_component') }}

{% endsnapshot %}