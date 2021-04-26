select  
    id as event_id, 
    name as event_name, 
    total_issued_tickets,
    _sdc_batched_at


from  {{ source('ticket_tailor', 'events') }}