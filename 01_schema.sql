-- Create the database
DROP DATABASE IF EXISTS client_retention_db;
CREATE DATABASE client_retention_db;
USE client_retention_db;

-- Core Tables
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tier ENUM('Free', 'SMB', 'Enterprise') NOT NULL DEFAULT 'SMB',
    onboard_date DATE NOT NULL,
    churn_risk_score DECIMAL(5,2) DEFAULT 0.0 CHECK (churn_risk_score BETWEEN 0 AND 1),
    INDEX idx_tier (tier),
    INDEX idx_risk (churn_risk_score)
);

CREATE TABLE interactions (
    interaction_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    type ENUM('Support', 'Sales', 'Feedback') NOT NULL,
    sentiment_score DECIMAL(3,2) CHECK (sentiment_score BETWEEN -1 AND 1), -- -1 (Negative) to +1 (Positive)
    duration_minutes INT CHECK (duration_minutes > 0),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    INDEX idx_client_id (client_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_sentiment (sentiment_score)
);

CREATE TABLE subscriptions (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    plan VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    renewal_date DATE NOT NULL,
    monthly_revenue DECIMAL(10,2) NOT NULL CHECK (monthly_revenue >= 0),
    status ENUM('Active', 'Cancelled', 'Past Due') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    INDEX idx_renewal (renewal_date),
    INDEX idx_status (status)
);

-- Usage Logs Table to track client activity/engagement
CREATE TABLE usage_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    feature_used VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duration_seconds INT CHECK (duration_seconds > 0),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    INDEX idx_usage_client (client_id, timestamp)
);
