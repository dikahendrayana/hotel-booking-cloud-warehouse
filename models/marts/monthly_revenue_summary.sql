SELECT

    arrival_date_year,
    arrival_date_month,
    SUM(ADR * (STAYS_IN_WEEKEND_NIGHTS + STAYS_IN_WEEK_NIGHTS)) AS total_revenue,
    COUNT(*) AS total_bookings,
    TO_DATE(arrival_date_month || ' 1, ' || arrival_date_year, 'MMMM DD, YYYY') AS booking_month
FROM {{ ref('stg_hotel_bookings') }}
WHERE IS_CANCELED = 0
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year, arrival_date_month
