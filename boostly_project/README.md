🚀 Core Functionality
✅ 1. Recognition (Send Kudos)

Allows one student to recognize another by transferring credits.

Business Rules:

Each student receives 100 system credits per month.

Cannot send credits to oneself (self-recognition blocked).

Cannot send more credits than available.

Monthly send limit = 100 credits.

Atomic DB updates prevent race conditions & double-spending.

Each request is idempotent using clientRequestId.

Status: Fully implemented
Security: Enforced at DB + application level
Audited: Yes

✅ 2. Endorsements (Likes/Cheers)

Students can endorse a recognition.

Business Rules:

One endorsement per recognition per user.

Endorsements DO NOT transfer credits.

Endorsements increment a counter via atomic updates.

Status: Fully implemented
Security: Permission-protected
Audited: Yes

✅ 3. Redemption (Convert to Voucher)

Students redeem earned credits at ₹5 per credit.

Business Rules:

Only credits received (not system credits) can be redeemed.

Redemption reduces received_credits_balance permanently.

Atomic conditional updates prevent negative balance.

Status: Fully implemented
Security: Ownership enforced
Audited: Yes

✅ 4. Monthly Reset & Carry Forward

A scheduled/resettable job that:

Resets system credits to 100 monthly.

Carries forward up to 50 unused credits.

Resets monthly send limit.

Idempotent using system_runs table.

Status: Fully implemented
Security: Admin-only
Audited: Yes

✅ 5. Leaderboard

Displays top recipients sorted by:

Credits received

Recognitions count

Endorsements count

Tie-breaker: Student ID

Status: Fully implemented
Security: Requires leaderboard:read permission

🔐 6. Security Model (Very Important)
🔑 API Key Structure

All requests must include:

X-API-KEY: keyId.secret


keyId = public identifier

secret = one-time visible token (hashed in DB)

Keys can be:

admin keys

frontend student keys (bound to owner_student_id)

🔐 Enforcement Layers

Boostly implements 10 layers of security (matching your principles):

Security Principle	Implementation
Least Privilege	Role-permission model, ownership binding
Complete Mediation	Every request passes APIKeyAuthFilter + PermissionAspect
Secure by Default	All endpoints deny without a valid key
Open Design	No obscurity, explicit DB rules & audit logs
Defense in Depth	DB constraints, application checks, audit logs, rate-limit
Separation of Privilege	Admin-only routes for key mgmt/reset
Economy of Mechanism	Simple atomic SQL updates, no complex locks
Psychological Acceptability	Clean UX, simple auth
Minimize Attack Surface	Only /api/* exposed
Log and Detect	Full audit_logs table

Status: Fully implemented end-to-end.

🛠 Technology & Frameworks Used
Backend (Java + Spring Boot)

Spring Web

Spring Data JPA

SQLite JDBC driver

HikariCP (connection pool)

Lombok

Scheduled jobs

Custom security filters

Aspect-oriented Authorization (@RequiresPermission)

Database

SQLite (zero-config, file-based)

Strict schema with:

CHECK constraints

Foreign keys

Triggers

Indexes

WAL mode

Frontend

Next.js 14+

React 18

TailwindCSS (One-UI + Instagram inspired)

Axios

Toast/Notifications (custom)

Jest + Testing Library (unit tests)

🧩 How to Access Each Functionality
Base URL (local):
http://localhost:8080/api

Required Header:
X-API-KEY: keyId.secret

🔵 1. Send Recognition

POST /api/recognitions

Example:

{
  "senderId": 1,
  "receiverId": 2,
  "credits": 10,
  "clientRequestId": "uuid-123"
}

🔵 2. Endorse Recognition

POST /api/endorsements

🔵 3. Redeem Credits

POST /api/redemptions

🔵 4. Leaderboard

GET /api/leaderboard?limit=10

🔵 5. Admin Key Management
POST /api/admin/apikeys/create
POST /api/admin/apikeys/revoke
POST /api/admin/apikeys/rotate

🖥️ Commands to Run
1. Install dependencies
sudo apt install sqlite3

2. Apply DB migrations
sqlite3 boostly.db < migrations/000_schema.sql

3. Build backend
mvn clean package

4. Run backend
java -jar target/boostly-backend.jar

5. Run frontend
cd frontend
npm install
npm run dev

6. Run demo script
bash demo/demo.sh

7. Run frontend tests
npm test

🧪 Edge Cases Handled
✔ Atomic credit deduction

Prevents double-spending during race conditions.

✔ Self-recognition blocked

DB trigger + application check.

✔ Sender cannot exceed monthly limit

Atomic update ensures limit enforcement.

✔ Endorsement uniqueness

DB UNIQUE(sender, recognition).

✔ Idempotency for all write operations

Using clientRequestId.

✔ Ownership binding to API keys

A key for student_id = 1 cannot act on student_id = 2.

✔ Revoked keys cannot authenticate
✔ Rate limiting

Token bucket per API key (429 on abuse).

✔ Secure DB constraints

CHECK + foreign keys + triggers.

✔ Carry-forward limit strictly max 50
✔ Leaderboard deterministic tie-breakers
✔ Audit logs for:

recognitions

endorsements

redemptions

key actions

system resets

🧪 Testing

Included:

SQL-based dry-run test file

Jest frontend tests

JUnit backend tests (templates included)

Postman collection with environment variables

admin_api_key

user_api_key

base_url

File: postman/boostly_collection.json

🎨 Frontend Design Notes

Inspired by:

Samsung One-UI → big tap areas, rounded corners, clear spacing

Instagram → activity feed layout, endorsements button, card visuals

User-friendly features:

Toast notifications

Mobile bottom navigation

Clean card-based feed

Auto-generated UUID for idempotency

Inline form validation
