USE client_retention_db;

-- Insert sample clients
INSERT INTO clients (name, email, tier, onboard_date, churn_risk_score) VALUES
('Nexus Digital Solutions', 'sarah@nexusdigital.com', 'Enterprise', '2023-01-15', 0.0),
('Bean There Coffee Co.', 'alex@beanthere.com', 'SMB', '2023-05-20', 0.0),
('MetroFit Gym', 'david@metrofit.com', 'Enterprise', '2022-11-01', 0.0),
('CloudTask Inc.', 'priya@cloudtask.io', 'SMB', '2023-03-10', 0.0),
('Wilson Consulting', 'james@wilsonconsulting.com', 'SMB', '2023-07-01', 0.0);

-- Insert sample subscriptions
INSERT INTO subscriptions (client_id, plan, start_date, renewal_date, monthly_revenue, status) VALUES
(1, 'Enterprise Plus', '2023-01-15', '2024-01-15', 2999.99, 'Active'),
(2, 'Premium Coffee Subscription', '2023-05-20', '2023-11-20', 45.00, 'Active'),
(3, 'Corporate Membership', '2022-11-01', '2023-11-01', 2500.00, 'Active'),
(4, 'Pro Plan', '2023-03-10', '2023-09-10', 99.99, 'Active'),
(5, 'Strategic Advisory', '2023-07-01', '2023-10-01', 1500.00, 'Active');

-- Insert sample interactions (mix of positive, neutral, negative)
INSERT INTO interactions (client_id, type, sentiment_score, duration_minutes, timestamp, notes) VALUES
(1, 'Sales', 0.8, 45, '2023-08-01 10:00:00', 'Discussed new campaign. Client excited.'),
(1, 'Support', -0.6, 20, '2023-08-15 14:30:00', 'Reporting module bug caused frustration.'),
(2, 'Feedback', 0.9, 10, '2023-06-01 09:15:00', 'Loved the first shipment!'),
(2, 'Support', 0.2, 5, '2023-08-25 16:45:00', 'Asked about changing delivery date. Resolved.'),
(3, 'Support', -0.8, 30, '2023-08-10 11:00:00', 'Complaint about locker room cleanliness. Very upset.'),
(4, 'Support', -0.4, 15, '2023-08-05 13:20:00', 'Feature request denied. Understood but disappointed.'),
(4, 'Support', -0.7, 25, '2023-08-12 15:30:00', 'Another small bug. Growing impatient.'),
(5, 'Sales', 0.6, 60, '2023-07-15 12:00:00', 'Kickoff meeting went well.'),
(5, 'Support', 0.1, 10, '2023-08-20 17:00:00', 'Quick billing question.');

-- Insert sample usage logs (showing engagement)
INSERT INTO usage_logs (client_id, feature_used, timestamp, duration_seconds) VALUES
(1, 'Dashboard', '2023-08-01 11:00:00', 300),
(1, 'Reporting', '2023-08-02 10:30:00', 600),
(1, 'Dashboard', '2023-08-15 15:00:00', 120), -- Less usage after support ticket
(4, 'Task Manager', '2023-08-01 09:00:00', 450),
(4, 'Task Manager', '2023-08-02 09:15:00', 500),
(4, 'Task Manager', '2023-08-03 09:05:00', 400), -- High engagement initially
(4, 'Task Manager', '2023-08-10 14:00:00', 100), -- Usage drops after negative interactions
(4, 'Task Manager', '2023-08-11 10:30:00', 150);
