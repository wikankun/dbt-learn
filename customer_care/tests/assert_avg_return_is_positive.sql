select
    avg_rating
from {{ ref('quiz_rating' )}}
where avg_rating <= 0
