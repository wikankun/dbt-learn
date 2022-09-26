select *
from {{ ref('quiz_rating' )}} qr
join {{ source('public', 'user_data') }} ud on ud.user_id = qr.user_id