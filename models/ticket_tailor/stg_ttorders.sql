select  
    id as order_id, 
    l.value:quantity::number(38,0) as refundedtix,
    refund_amount,
    status,
    _sdc_batched_at

from  {{ source('ticket_tailor', 'orders') }}
,table (flatten (line_items)) l 
where status = 'completed'
and refund_amount > 0