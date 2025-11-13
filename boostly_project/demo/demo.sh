#!/usr/bin/env bash
set -e
DB=boostly.db
echo "Applying migrations..."
sqlite3 $DB < migrations/000_schema.sql
echo "Seeding demo data..."
sqlite3 $DB < backend/demo-seed.sql
echo "Creating admin API key (insecure demo) - hashed with bcrypt via node (not available here)."
echo "Please run ApiKeyService.createApiKey in app or use admin controller to create keys."
echo "Sample curl flows (replace USER_KEY with keyId.secret):"
echo "curl -X POST http://localhost:8080/api/recognitions -H 'Content-Type: application/json' -H 'X-API-KEY: USER_KEY' -d '{"senderId":1,"receiverId":2,"credits":10,"clientRequestId":"req-1"}'"
