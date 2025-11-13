PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- students
CREATE TABLE IF NOT EXISTS students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NULL,
    system_credits INTEGER NOT NULL DEFAULT 100 CHECK (system_credits >= 0 AND system_credits <= 150),
    received_credits_balance INTEGER NOT NULL DEFAULT 0 CHECK (received_credits_balance >= 0),
    available_credits INTEGER NOT NULL DEFAULT 100 CHECK (available_credits >= 0),
    monthly_sent_credits INTEGER NOT NULL DEFAULT 0 CHECK (monthly_sent_credits >= 0 AND monthly_sent_credits <= 100),
    total_received_credits INTEGER NOT NULL DEFAULT 0,
    total_recognitions_received INTEGER NOT NULL DEFAULT 0,
    total_endorsements_received INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL
);

-- recognitions
CREATE TABLE IF NOT EXISTS recognitions (
    recognition_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_request_id TEXT UNIQUE NULL,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    credits_sent INTEGER NOT NULL CHECK (credits_sent > 0),
    endorsements_count INTEGER NOT NULL DEFAULT 0 CHECK (endorsements_count >= 0),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES students(student_id) ON DELETE RESTRICT,
    FOREIGN KEY (receiver_id) REFERENCES students(student_id) ON DELETE RESTRICT
);

-- endorsements
CREATE TABLE IF NOT EXISTS endorsements (
    endorsement_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_request_id TEXT UNIQUE NULL,
    recognition_id INTEGER NOT NULL,
    endorser_id INTEGER NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recognition_id) REFERENCES recognitions(recognition_id) ON DELETE CASCADE,
    FOREIGN KEY (endorser_id) REFERENCES students(student_id) ON DELETE RESTRICT,
    UNIQUE (recognition_id, endorser_id)
);

-- redemptions
CREATE TABLE IF NOT EXISTS redemptions (
    redemption_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_request_id TEXT UNIQUE NULL,
    student_id INTEGER NOT NULL,
    credits_redeemed INTEGER NOT NULL CHECK (credits_redeemed > 0),
    amount_in_paise INTEGER NOT NULL CHECK (amount_in_paise >= 0),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE RESTRICT
);

-- api_keys (id.secret pattern)
CREATE TABLE IF NOT EXISTS api_keys (
    api_key_id INTEGER PRIMARY KEY AUTOINCREMENT,
    key_id TEXT NOT NULL UNIQUE,
    secret_hash TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    owner_student_id INTEGER NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revoked_at DATETIME NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_api_keys_keyid ON api_keys(key_id);

-- roles, role_permissions, audit_logs, system_runs minimal
CREATE TABLE IF NOT EXISTS roles (
    role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);
CREATE TABLE IF NOT EXISTS role_permissions (
    role_permission_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_id INTEGER NOT NULL,
    permission TEXT NOT NULL,
    UNIQUE (role_id, permission)
);
CREATE TABLE IF NOT EXISTS audit_logs (
    audit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    actor_student_id INTEGER NULL,
    actor_api_key_id INTEGER NULL,
    action TEXT NOT NULL,
    table_name TEXT NULL,
    row_id INTEGER NULL,
    details TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS system_runs (
    run_key TEXT PRIMARY KEY,
    run_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
