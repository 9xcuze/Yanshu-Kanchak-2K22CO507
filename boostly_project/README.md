
# 🚀 Boostly: Peer Recognition & Rewards Platform

Boostly is a secure recognition and rewards platform where students can appreciate peers by sending credits, endorsing recognitions, redeeming earned points, and tracking progress through leaderboards.  
Built with Java (Spring Boot) for the backend and Next.js (React) for the frontend, it emphasizes security, atomicity, and transparency through audit logging.

---

## ⚙️ Core Functionalities

### 1. Recognition (Send Kudos)
Allows one student to recognize another by transferring credits.

**Business Rules:**
- Each student receives 100 system credits per month.
- Self-recognition is blocked.
- Cannot send more credits than available.
- Monthly send limit: 100 credits.
- Atomic DB updates prevent race conditions and double-spending.
- Idempotent requests using `clientRequestId`.

**Status:** Fully implemented  
**Security:** Enforced at DB and application levels  
**Audited:** Yes

---

### 2. Endorsements (Likes/Cheers)
Students can endorse an existing recognition.

**Business Rules:**
- One endorsement per recognition per user.
- Endorsements do not transfer credits.
- Atomic counter increment for endorsements.

**Status:** Fully implemented  
**Security:** Permission-protected  
**Audited:** Yes

---

### 3. Redemption (Convert to Voucher)
Students can convert earned (received) credits into redeemable vouchers.

**Business Rules:**
- Only received credits are redeemable.
- Redemption rate: ₹5 per credit.
- Received credit balance decreases permanently after redemption.
- Atomic updates prevent negative balances.

**Status:** Fully implemented  
**Security:** Ownership enforced  
**Audited:** Yes

---

### 4. Monthly Reset & Carry Forward
A scheduled and idempotent job resets system credits and enforces carry-forward limits.

**Business Rules:**
- Reset to 100 system credits monthly.
- Carry forward up to 50 unused credits.
- Reset monthly send limit.
- Uses `system_runs` table for idempotency.

**Status:** Fully implemented  
**Security:** Admin-only  
**Audited:** Yes

---

### 5. Leaderboard
Displays top recipients sorted by:
1. Credits received
2. Recognitions count
3. Endorsements count  

Tie-breaker: Student ID

**Status:** Fully implemented  
**Security:** Requires `leaderboard:read` permission

---

## 🔐 Security Model

### API Key Structure

All API requests must include:
```
X-API-KEY: keyId.secret
```

- `keyId` = public identifier  
- `secret` = one-time visible token (hashed in the database)

**Key Types:**
- Admin keys  
- Student (frontend) keys bound to `owner_student_id`

---

### Enforcement Principles

| Security Principle | Implementation |
|--------------------|----------------|
| Least Privilege | Role-permission model; ownership binding |
| Complete Mediation | All routes filtered by `APIKeyAuthFilter` + `PermissionAspect` |
| Secure by Default | Deny all by default; explicit permission required |
| Open Design | Transparent security and DB constraint architecture |
| Defense in Depth | DB constraints, app checks, audit logs, rate limits |
| Separation of Privilege | Admin-only operations for key management |
| Economy of Mechanism | Simple atomic SQL updates, minimal locks |
| Psychological Acceptability | Clear UX and consistent auth flow |
| Minimize Attack Surface | Only `/api/*` endpoints exposed |
| Log and Detect | Comprehensive `audit_logs` tracking |

---

## 🛠️ Technology Stack

### Backend
- Java + Spring Boot  
- Spring Web, Data JPA  
- SQLite (zero-config, file-based) with HikariCP  
- Lombok  
- Scheduled jobs  
- Aspect-oriented permissions (`@RequiresPermission`)  

### Database Features
- Foreign keys, triggers, and CHECK constraints  
- WAL journaling mode for high concurrency  
- Strict schema design with triggers for data integrity  
- Indexing for optimized leaderboard queries

### Frontend
- Next.js 14+, React 18  
- TailwindCSS (Samsung One-UI + Instagram inspired)  
- Axios for API interaction  
- Toast notifications  
- Jest + Testing Library for frontend testing  

---

## 🌐 API Endpoints

**Base URL (local):**
```
http://localhost:8080/api
```

**Required Header:**
```
X-API-KEY: keyId.secret
```

### Endpoints

1. **Send Recognition**  
```
POST /api/recognitions
```
Example Request:
```
{
  "senderId": 1,
  "receiverId": 2,
  "credits": 10,
  "clientRequestId": "uuid-123"
}
```

2. **Endorse Recognition**  
```
POST /api/endorsements
```

3. **Redeem Credits**  
```
POST /api/redemptions
```

4. **Leaderboard**  
```
GET /api/leaderboard?limit=10
```

5. **Admin Key Management**  
```
POST /api/admin/apikeys/create
POST /api/admin/apikeys/revoke
POST /api/admin/apikeys/rotate
```

---

## 💻 Setup Instructions

### 1. Install Dependencies
```
sudo apt install sqlite3
```

### 2. Apply Database Migrations
```
sqlite3 boostly.db < migrations/000_schema.sql
```

### 3. Build Backend
```
mvn clean package
```

### 4. Run Backend
```
java -jar target/boostly-backend.jar
```

### 5. Run Frontend
```
cd frontend
npm install
npm run dev
```

### 6. Run Demo Script
```
bash demo/demo.sh
```

### 7. Run Frontend Tests
```
npm test
```

---

## 🧪 Edge Cases Handled

- Atomic credit deductions (no race conditions)
- Self-recognition blocked (application + DB trigger)
- Monthly credit send limit strictly enforced
- Unique endorsement per user per recognition
- Idempotent write operations using `clientRequestId`
- API key bound to `student_id` for ownership enforcement
- Revoked keys immediately unauthorized
- Per-key rate limiting with token bucket algorithm
- Secure DB enforcement using constraints and triggers
- Strict carry-forward limit of 50 credits
- Deterministic leaderboard sorting rules
- Comprehensive audit logs for:
  - Recognitions
  - Endorsements
  - Redemptions
  - API key events
  - System reset runs

---

## 🧩 Testing Framework

**Included Tests:**
- SQL-based dry-run files for data validation
- Jest + Testing Library for frontend units
- JUnit templates for backend services
- Postman collection under `postman/boostly_collection.json`

**Postman Environment Variables:**
- `admin_api_key`
- `user_api_key`
- `base_url`

---

## 🎨 Frontend Design

**Inspiration:**
- Samsung One-UI for touch-friendly layout and clear visuals  
- Instagram for social card design and activity feed interactions  

**UX Design Features:**
- Toast notifications for feedback  
- Inline form validation  
- UUID auto-generation for idempotency  
- Mobile-friendly layouts  
- Bottom navigation for easy access  

---

## 📜 License
Open-sourced for educational and non-commercial use under the MIT License.

---

## 👨‍💻 Contributors
**Backend:** Java + Spring Boot  
**Frontend:** Next.js + React  
**Database:** SQLite  

---

