-- Demo seed: create two students
INSERT INTO students (name) VALUES ('Alice');
INSERT INTO students (name) VALUES ('Bob');

-- Create roles
INSERT OR IGNORE INTO roles (name, description) VALUES ('admin', 'full admin');
INSERT OR IGNORE INTO roles (name, description) VALUES ('frontend', 'frontend user');

-- create role_permissions examples
INSERT OR IGNORE INTO role_permissions (role_id, permission)
SELECT role_id, 'recognitions:create' FROM roles WHERE name='frontend';
INSERT OR IGNORE INTO role_permissions (role_id, permission)
SELECT role_id, 'endorsements:create' FROM roles WHERE name='frontend';
INSERT OR IGNORE INTO role_permissions (role_id, permission)
SELECT role_id, 'redemptions:create' FROM roles WHERE name='frontend';
INSERT OR IGNORE INTO role_permissions (role_id, permission)
SELECT role_id, 'admin:manage_keys' FROM roles WHERE name='admin';
