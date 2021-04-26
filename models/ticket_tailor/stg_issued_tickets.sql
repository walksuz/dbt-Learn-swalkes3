select  
    id as issued_tickets_id, 
    event_id,
    order_id,
   status,
   voided_at,
    _sdc_batched_at    

from  {{ source('ticket_tailor', 'issued_tickets') }}
where status = 'valid'