USE client_retention_db;

DELIMITER $$

-- Procedure to calculate churn risk
CREATE PROCEDURE calculate_churn_risk()
BEGIN
    -- Temporary table to hold calculated risks
    DROP TEMPORARY TABLE IF EXISTS temp_risk_data;
    CREATE TEMPORARY TABLE temp_risk_data (
        client_id INT PRIMARY KEY,
        new_risk_score DECIMAL(5,2)
    );

    -- Calculate risk based on: sentiment & usage drop
    INSERT INTO temp_risk_data
    WITH recent_activity AS (
        SELECT
            i.client_id,
            -- Negative sentiment factor (50% weight)
            COALESCE(0.5 * AVG(CASE WHEN i.timestamp > DATE_SUB(NOW(), INTERVAL 30 DAY) THEN -i.sentiment_score ELSE 0 END), 0) AS sentiment_factor,
            -- Usage drop factor (50% weight)
            COALESCE(0.5 * (1 - (COUNT(ul.log_id) / NULLIF( (SELECT COUNT(log_id) FROM usage_logs WHERE client_id = i.client_id AND timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY) AND timestamp > DATE_SUB(NOW(), INTERVAL 60 DAY)), 0))), 0) AS usage_factor
        FROM clients c
        LEFT JOIN interactions i ON c.client_id = i.client_id
        LEFT JOIN usage_logs ul ON c.client_id = ul.client_id AND ul.timestamp > DATE_SUB(NOW(), INTERVAL 30 DAY)
        GROUP BY i.client_id
    )
    SELECT
        client_id,
        LEAST(1.0, GREATEST(0.0, (sentiment_factor + usage_factor))) AS calculated_risk -- Ensure score is between 0-1
    FROM recent_activity;

    -- Update the main clients table
    UPDATE clients c
    JOIN temp_risk_data trd ON c.client_id = trd.client_id
    SET c.churn_risk_score = trd.new_risk_score;

    DROP TEMPORARY TABLE temp_risk_data;
END$$

-- View: High Risk Clients
CREATE VIEW vw_high_risk_clients AS
SELECT
    c.client_id,
    c.name,
    c.email,
    c.tier,
    c.churn_risk_score,
    s.plan,
    s.renewal_date
FROM clients c
JOIN subscriptions s ON c.client_id = s.client_id
WHERE c.churn_risk_score >= 0.6
AND s.status = 'Active'
ORDER BY c.churn_risk_score DESC;

-- View: Upsell Opportunities (High usage but lower tier plan)
CREATE VIEW vw_upsell_opportunities AS
SELECT
    c.client_id,
    c.name,
    c.tier,
    c.churn_risk_score,
    s.plan,
    s.monthly_revenue,
    COUNT(ul.log_id) AS logins_last_30_days
FROM clients c
JOIN subscriptions s ON c.client_id = s.client_id
JOIN usage_logs ul ON c.client_id = ul.client_id AND ul.timestamp > DATE_SUB(NOW(), INTERVAL 30 DAY)
WHERE c.tier != 'Enterprise'
AND s.status = 'Active'
GROUP BY c.client_id, c.name, c.tier, s.plan, s.monthly_revenue
HAVING logins_last_30_days > 10 -- Highly engaged
ORDER BY logins_last_30_days DESC;

DELIMITER ;
