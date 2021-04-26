{{ config
    (
        materialized = 'table'
    )

    }}

with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),


final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,        
        payments.amount       

    from orders

    left join payments using (order_id)

)


select * from final

