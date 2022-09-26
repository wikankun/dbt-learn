{{ config(materialized='table') }}
{% set quiz = ["Q1", "Q2", "Q3", "Q4", "Q5", "Q6"] %}

with pivot_table as (

    select
        user_id,
        survey_state,
        {% for q in quiz %}
        coalesce(sum(case when survey_question = '{{q}}' then answer_rating end), 0) as {{q}}_rating,
        {% endfor %}
        round(sum(answer_rating) / 6.0, 2) avg_rating
    from
        {{ source('public', 'survey') }}
    group by
        user_id, survey_state
    order by user_id

)
select
	u.directorate,
	pt.*
from
	pivot_table pt
join {{ source('public', 'user_data') }} u on
	u.id = pt.user_id
order by
	u.directorate, pt.user_id
