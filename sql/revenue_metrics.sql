/* 
Project 2. Revenue Metrics
Final dataset for Tableau dashboard
*/

WITH monthly_revenue AS (
    SELECT
        user_id,
        game_name,
        DATE_TRUNC('month', payment_date)::date AS payment_month,
        SUM(revenue_amount_usd) AS total_revenue
    FROM project.games_payments
    GROUP BY user_id, game_name, payment_month
),

lag_lead_revenue_month AS (
    SELECT
        *,
        payment_month - INTERVAL '1 month' AS prev_calendar_month,
        payment_month + INTERVAL '1 month' AS next_calendar_month,
        LAG(total_revenue) OVER (
            PARTITION BY user_id
            ORDER BY payment_month
        ) AS prev_paid_month_revenue,
        LAG(payment_month) OVER (
            PARTITION BY user_id
            ORDER BY payment_month
        ) AS prev_paid_month,
        LEAD(payment_month) OVER (
            PARTITION BY user_id
            ORDER BY payment_month
        ) AS next_paid_month
    FROM monthly_revenue
),

CTE_metrics AS (
    SELECT
        user_id,
        game_name,
        payment_month,
        total_revenue AS mrr,

        -- New metrics
        CASE 
            WHEN prev_paid_month IS NULL 
            THEN total_revenue 
        END AS new_mrr,

        CASE 
            WHEN prev_paid_month IS NULL 
            THEN 1 
        END AS new_paid_user,

        -- Expansion / Contraction
        CASE
            WHEN prev_calendar_month = prev_paid_month
             AND total_revenue > prev_paid_month_revenue
            THEN total_revenue - prev_paid_month_revenue
        END AS expansion_mrr,

        CASE
            WHEN prev_calendar_month = prev_paid_month
             AND total_revenue < prev_paid_month_revenue
            THEN total_revenue - prev_paid_month_revenue
        END AS contraction_mrr,

        -- Churn
        CASE
            WHEN next_paid_month IS NULL
              OR next_paid_month != next_calendar_month
            THEN total_revenue
        END AS churned_revenue,

        CASE
            WHEN next_paid_month IS NULL
              OR next_paid_month != next_calendar_month
            THEN 1
        END AS churned_user

    FROM lag_lead_revenue_month
)

SELECT
    m.user_id,
    m.game_name,
    m.payment_month,
    m.mrr,
    m.new_mrr,
    m.new_paid_user,
    m.expansion_mrr,
    m.contraction_mrr,
    m.churned_revenue,
    m.churned_user,
    u.language,
    u.has_older_device_model,
    u.age
FROM CTE_metrics m
LEFT JOIN project.games_paid_users u
    USING (user_id);
