CREATE TABLE abc123_users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('reserver', 'administrator')),
    age INT CHECK (age >= 0),
    consent_given BOOLEAN NOT NULL DEFAULT FALSE -- User consent for data processing
);
-- Using pgcrypto extension for encryption
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

ALTER TABLE abc123_users
ADD COLUMN encrypted_email BYTEA;

-- Encrypt existing email addresses
UPDATE abc123_users SET encrypted_email = pgp_sym_encrypt(email, 'encryption_key');
ALTER TABLE abc123_users DROP COLUMN email; -- Remove plain text email column

CREATE TABLE abc123_consent (
    consent_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES abc123_users(user_id),
    consent_type VARCHAR(100) NOT NULL,
    consent_given_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE ROLE reserver;
CREATE ROLE administrator;

GRANT SELECT, INSERT, UPDATE, DELETE ON abc123_users TO administrator;
GRANT SELECT ON abc123_resources, abc123_reservations TO reserver;
CREATE TABLE abc123_deleted_users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    deletion_requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example function to handle data deletion requests
CREATE OR REPLACE FUNCTION delete_user_data(user_id INT) RETURNS VOID AS $$
BEGIN
    INSERT INTO abc123_deleted_users (user_id, name)
    SELECT user_id, name FROM abc123_users WHERE user_id = user_id;

    DELETE FROM abc123_users WHERE user_id = user_id;
END;
$$ LANGUAGE plpgsql;

-- Schedule deletion function (e.g., every month)
CREATE EXTENSION IF NOT EXISTS pg_cron;
SELECT cron.schedule('0 0 1 * *', 'CALL delete_user_data(user_id)');
CREATE TABLE abc123_audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

-- Example trigger to log updates to the users table
CREATE OR REPLACE FUNCTION log_user_update() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO abc123_audit_logs (user_id, action, details)
    VALUES (NEW.user_id, 'Update', 'Updated user details');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_user_update
AFTER UPDATE ON abc123_users
FOR EACH ROW EXECUTE FUNCTION log_user_update();

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

