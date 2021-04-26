{{ config
    (
        materialized = 'table'
    )

    }}

with ttorders as (

    select * from {{ ref('stg_ttorders') }}

),

events as (

    select * from {{ ref('stg_events') }}

),

issued_tickets as (

    select distinct event_id, order_id from {{ ref('stg_issued_tickets') }} 

),


refund_tix as (

    select
        issued_tickets.event_id,
        sum(ttorders.refundedtix) as refunded_tickets
       
    from issued_tickets
    join ttorders using (order_id)

    group by issued_tickets.event_id

),

event_tix as (

    select
        event_id,
        sum(total_issued_tickets) tix_sold
       
    from events 
    group by 1

),


final as (

    select
        coalesce(event_tix.event_id, refund_tix.event_id) Event,
        coalesce(sum(refund_tix.refunded_tickets),0) refunds,
        coalesce(sum(event_tix.tix_sold),0) tickets_sold
        

    from refund_tix
    full outer join event_tix  using (event_id)
    group by coalesce(event_tix.event_id, refund_tix.event_id)

)

select * from final