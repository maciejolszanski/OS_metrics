{% snapshot host_scd %}

{{
    config(
      unique_key='host',
      strategy='timestamp',
      updated_at='timestamp'
    )
}}


select * from {{ ref('bronze_host') }}

{% endsnapshot %}