# GreenXchange - Technical Architecture Documentation

## Table of Contents
1. [System Overview](#system-overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Technology Stack](#technology-stack)
4. [Database Design](#database-design)
5. [API Architecture](#api-architecture)
6. [Authentication & Authorization](#authentication--authorization)
7. [Payment Flow](#payment-flow)
8. [Government Integration](#government-integration)
9. [Security](#security)
10. [Scalability](#scalability)
11. [Deployment](#deployment)

---

## System Overview

GreenXchange is a three-sided marketplace platform connecting:
- **Sellers** (carbon credit generators)
- **Buyers** (corporations, individuals)
- **Government** (compliance and verification)

### Core Modules

1. **User Management** - Multi-role authentication and profiles
2. **Registration Service** - Government registration assistance
3. **Project Management** - Carbon credit project tracking
4. **Marketplace** - Credit listing and trading
5. **Transaction Engine** - Payment processing and escrow
6. **Compliance System** - Government reporting and audit
7. **Support System** - Multi-channel customer support
8. **Notification Engine** - Email, SMS, WhatsApp, In-app

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND LAYER                        │
│  Next.js 14 (App Router) + TypeScript + Tailwind CSS       │
│  Multi-language Support (i18next)                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      API LAYER (Next.js)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Auth   │  │  Users   │  │ Projects │  │Marketplace│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Payments  │  │Documents │  │Compliance│  │ Support  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATABASE LAYER                            │
│              Supabase (PostgreSQL)                           │
│  16 Tables + Views + Triggers + RLS Policies                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  EXTERNAL INTEGRATIONS                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │DigiLocker│  │ Aadhaar  │  │  e-Sign  │  │ Razorpay │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ WhatsApp │  │   SMS    │  │SendGrid  │  │   GST    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Technology Stack

### Frontend
- **Framework:** Next.js 14 (React 18)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** Radix UI + Shadcn
- **State Management:** React Context + Hooks
- **Forms:** React Hook Form + Zod validation
- **Internationalization:** i18next
- **Charts:** Recharts
- **File Upload:** React Dropzone

### Backend
- **Runtime:** Node.js 18+
- **Framework:** Next.js API Routes
- **Database:** PostgreSQL (via Supabase)
- **ORM:** Supabase Client
- **Authentication:** Supabase Auth
- **File Storage:** Supabase Storage

### Infrastructure
- **Hosting:** Vercel (Frontend + API)
- **Database:** Supabase Cloud
- **CDN:** Vercel Edge Network
- **Region:** Asia-Pacific (Mumbai)

### Third-Party Services
- **Payment:** Razorpay
- **Government APIs:** DigiLocker, Aadhaar, e-Sign
- **Communication:** WhatsApp Business API, SMS Gateway, SendGrid
- **Monitoring:** Sentry (Error tracking)
- **Analytics:** Google Analytics

---

## Database Design

### Entity Relationship Overview

```
users (1) ──── (1) seller_profiles
  │                     │
  │                     │
  │              (1) ───┴─── (N) carbon_projects
  │                              │
  │                              │
  │                       (1) ───┴─── (N) registration_applications
  │                              │
  │                              │
  │                       (1) ───┴─── (N) carbon_credits
  │                                      │
  │                                      │
  │                               (1) ───┴─── (N) marketplace_listings
  │                                              │
  │                                              │
users (1) ──── (N) transactions ────────────────┘
  │
  │
  └──── (1) buyer_profiles
```

### Key Tables

1. **users** - Core user accounts
2. **seller_profiles** - Seller business info
3. **buyer_profiles** - Buyer company info
4. **carbon_projects** - Project details
5. **registration_applications** - Govt registration tracking
6. **documents** - Document storage
7. **carbon_credits** - Credit inventory
8. **marketplace_listings** - Active listings
9. **transactions** - Trade records
10. **compliance_logs** - Govt compliance
11. **support_tickets** - Customer support
12. **notifications** - Multi-channel notifications
13. **audit_logs** - Complete audit trail
14. **educational_content** - Learning resources
15. **system_settings** - Platform configuration

### Database Features

- **Row Level Security (RLS)** - User-level data isolation
- **Triggers** - Auto-update timestamps
- **Views** - Optimized queries for common operations
- **Indexes** - Performance optimization
- **Foreign Keys** - Data integrity
- **Check Constraints** - Data validation

---

## API Architecture

### RESTful API Endpoints

#### Authentication
```
POST   /api/auth/signup
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh
GET    /api/auth/me
```

#### Users
```
GET    /api/users/profile
PUT    /api/users/profile
POST   /api/users/kyc/verify
GET    /api/users/kyc/status
```

#### Projects
```
GET    /api/projects
POST   /api/projects
GET    /api/projects/:id
PUT    /api/projects/:id
DELETE /api/projects/:id
POST   /api/projects/:id/submit
GET    /api/projects/:id/status
```

#### Registration Applications
```
POST   /api/applications
GET    /api/applications/:id
PUT    /api/applications/:id
POST   /api/applications/:id/submit-to-govt
GET    /api/applications/:id/track
```

#### Marketplace
```
GET    /api/marketplace/listings
GET    /api/marketplace/listings/:id
POST   /api/marketplace/listings
PUT    /api/marketplace/listings/:id
DELETE /api/marketplace/listings/:id
GET    /api/marketplace/search
GET    /api/marketplace/filters
```

#### Transactions
```
POST   /api/transactions/initiate
POST   /api/transactions/:id/payment
POST   /api/transactions/:id/verify
GET    /api/transactions/:id
GET    /api/transactions/history
POST   /api/transactions/:id/esign
```

#### Documents
```
POST   /api/documents/upload
GET    /api/documents/:id
DELETE /api/documents/:id
POST   /api/documents/:id/verify
GET    /api/documents/digilocker/fetch
```

#### Support
```
POST   /api/support/tickets
GET    /api/support/tickets/:id
PUT    /api/support/tickets/:id
POST   /api/support/tickets/:id/messages
GET    /api/support/tickets
```

#### Admin
```
GET    /api/admin/dashboard
GET    /api/admin/applications
PUT    /api/admin/applications/:id/approve
PUT    /api/admin/applications/:id/reject
GET    /api/admin/users
GET    /api/admin/transactions
GET    /api/admin/compliance
```

---

## Authentication & Authorization

### Authentication Flow

1. **User Registration**
   - Email/Phone + Password
   - Aadhaar verification (optional initially)
   - Email verification
   - Account creation

2. **Login**
   - Email/Phone + Password
   - JWT token generation
   - Refresh token for session management

3. **Session Management**
   - Access token (15 min expiry)
   - Refresh token (7 days expiry)
   - Automatic token refresh

### Authorization Levels

1. **Public** - Unauthenticated users
   - View marketplace listings
   - View educational content
   - Browse public pages

2. **Seller** - Authenticated sellers
   - Manage projects
   - List credits
   - View sales
   - Access support

3. **Buyer** - Authenticated buyers
   - Browse marketplace
   - Purchase credits
   - View purchase history
   - Access support

4. **Advisor** - Carbon credit advisors
   - View assigned applications
   - Update application status
   - Communicate with sellers

5. **Admin** - Platform administrators
   - Full system access
   - User management
   - Application approval
   - System configuration

### Row Level Security (RLS)

Implemented at database level using Supabase RLS:
- Users can only access their own data
- Admins have elevated permissions
- Public data is accessible to all
- Audit logs track all access

---

## Payment Flow

### Transaction Lifecycle

```
1. Buyer initiates purchase
   ↓
2. Create transaction record (status: pending)
   ↓
3. Calculate amounts (total, commission, GST, TDS)
   ↓
4. Create Razorpay order
   ↓
5. Buyer completes payment
   ↓
6. Verify payment with Razorpay
   ↓
7. Update transaction (status: paid)
   ↓
8. Hold funds in escrow
   ↓
9. Generate e-Sign documents
   ↓
10. Both parties sign
   ↓
11. Transfer credits to buyer
   ↓
12. Release payment to seller (status: released_to_seller)
   ↓
13. Generate certificates and invoices
   ↓
14. Send notifications
```

### Payment Components

1. **Order Creation**
   ```javascript
   const order = await razorpay.orders.create({
     amount: totalAmount * 100, // paise
     currency: 'INR',
     receipt: transactionNumber,
     notes: { transaction_id: txnId }
   });
   ```

2. **Payment Verification**
   ```javascript
   const isValid = verifyPaymentSignature({
     order_id: orderId,
     payment_id: paymentId,
     signature: signature
   });
   ```

3. **Seller Payout**
   ```javascript
   const payout = await razorpay.payouts.create({
     account_number: sellerAccount,
     amount: sellerAmount * 100,
     currency: 'INR',
     mode: 'IMPS',
     purpose: 'payout'
   });
   ```

### Financial Calculations

```javascript
// Example transaction calculation
const creditQuantity = 100;
const pricePerCredit = 500; // INR
const subtotal = creditQuantity * pricePerCredit; // 50,000

const platformCommission = subtotal * 0.03; // 3% = 1,500
const gstAmount = platformCommission * 0.18; // 18% = 270
const tdsAmount = subtotal * 0.01; // 1% TDS = 500

const buyerTotal = subtotal + gstAmount; // 50,270
const sellerPayout = subtotal - platformCommission - tdsAmount; // 48,000
```

---

## Government Integration

### DigiLocker Integration

**Purpose:** Fetch and verify government-issued documents

```javascript
// OAuth flow
1. Redirect user to DigiLocker
2. User authorizes access
3. Receive authorization code
4. Exchange for access token
5. Fetch documents (Aadhaar, PAN, etc.)
6. Store document references
```

### Aadhaar e-KYC

**Purpose:** Identity verification

```javascript
// KYC flow
1. Collect Aadhaar number
2. Send OTP to registered mobile
3. User enters OTP
4. Verify OTP with UIDAI
5. Receive demographic data
6. Store encrypted Aadhaar hash
```

### e-Sign Integration

**Purpose:** Digital signature for legal documents

```javascript
// e-Sign flow
1. Generate PDF document
2. Upload to e-Sign service
3. Send signing request to parties
4. Parties authenticate via Aadhaar OTP
5. Document gets digitally signed
6. Download signed document
7. Store with transaction
```

### GST Verification

**Purpose:** Verify business registration

```javascript
// GST verification
1. Collect GSTIN
2. Call GST API
3. Verify business details
4. Store verification status
```

---

## Security

### Data Protection

1. **Encryption at Rest**
   - Database encryption (Supabase)
   - File encryption (Supabase Storage)
   - Sensitive fields encrypted (Aadhaar, bank details)

2. **Encryption in Transit**
   - HTTPS/TLS 1.3
   - Secure WebSocket connections
   - API key encryption

3. **Password Security**
   - bcrypt hashing (10 rounds)
   - Password strength requirements
   - No plain text storage

### API Security

1. **Authentication**
   - JWT tokens
   - Token expiration
   - Refresh token rotation

2. **Rate Limiting**
   - 100 requests per 15 minutes per IP
   - Stricter limits for sensitive endpoints
   - DDoS protection via Vercel

3. **Input Validation**
   - Zod schema validation
   - SQL injection prevention
   - XSS protection
   - CSRF tokens

### Compliance

1. **Data Privacy**
   - Digital Personal Data Protection Act 2023
   - User consent management
   - Right to deletion
   - Data portability

2. **Financial Compliance**
   - PCI-DSS (via Razorpay)
   - AML/KYC requirements
   - GST compliance
   - TDS deduction

3. **Audit Trail**
   - All actions logged
   - Immutable audit logs
   - 7-year retention
   - Government access portal

---

## Scalability

### Horizontal Scaling

1. **Stateless API**
   - No server-side sessions
   - JWT-based authentication
   - Can scale to multiple instances

2. **Database**
   - Supabase auto-scaling
   - Read replicas for queries
   - Connection pooling

3. **File Storage**
   - CDN distribution
   - Lazy loading
   - Image optimization

### Performance Optimization

1. **Frontend**
   - Code splitting
   - Lazy loading
   - Image optimization (Next.js Image)
   - Static generation where possible

2. **Backend**
   - Database indexes
   - Query optimization
   - Caching (Redis - future)
   - Background jobs for heavy tasks

3. **Monitoring**
   - Error tracking (Sentry)
   - Performance monitoring
   - Database query analysis
   - User analytics

### Load Handling

**Expected Load (Year 1):**
- 10,000 registered users
- 500 concurrent users
- 100 transactions/day
- 1,000 API requests/minute

**Infrastructure Capacity:**
- Vercel: Unlimited bandwidth
- Supabase: 500GB database, 50GB storage
- Can scale to 100,000+ users

---

## Deployment

### Development Environment

```bash
# Local setup
git clone https://github.com/greenxchange365/greenxchange-platform.git
cd greenxchange-platform
npm install
cp .env.example .env.local
# Fill in environment variables
npm run dev
```

### Staging Environment

- **URL:** staging.greenxchange.in
- **Branch:** develop
- **Auto-deploy:** On push to develop
- **Database:** Separate Supabase project

### Production Environment

- **URL:** greenxchange.in
- **Branch:** main
- **Deploy:** Manual approval required
- **Database:** Production Supabase project
- **Monitoring:** Full error tracking and analytics

### CI/CD Pipeline

```yaml
# GitHub Actions workflow
1. Code push to branch
2. Run linting (ESLint)
3. Run type checking (TypeScript)
4. Run tests (Jest)
5. Build application
6. Deploy to Vercel
7. Run smoke tests
8. Notify team
```

### Database Migrations

```bash
# Create migration
npm run db:migrate:create migration_name

# Run migrations
npm run db:migrate

# Rollback
npm run db:migrate:rollback
```

### Backup Strategy

1. **Database**
   - Daily automated backups (Supabase)
   - Point-in-time recovery
   - 30-day retention

2. **Files**
   - Replicated across regions
   - Version control
   - 90-day retention

3. **Code**
   - Git version control
   - Tagged releases
   - Rollback capability

---

## Monitoring & Maintenance

### Health Checks

- API endpoint monitoring
- Database connection checks
- External service availability
- Response time tracking

### Alerts

- Error rate threshold
- Response time degradation
- Database connection issues
- Payment gateway failures
- Government API downtime

### Maintenance Windows

- Scheduled: Sunday 2:00 AM - 4:00 AM IST
- Emergency: As needed with user notification
- Zero-downtime deployments preferred

---

## Future Enhancements

### Phase 2 (Months 6-12)

1. **Blockchain Integration**
   - Polygon network
   - NFT-based certificates
   - Immutable transaction records

2. **Mobile Apps**
   - React Native
   - iOS and Android
   - Offline support

3. **AI/ML Features**
   - Fraud detection
   - Price prediction
   - Eligibility assessment
   - Chatbot support

4. **Advanced Analytics**
   - Business intelligence dashboard
   - Predictive analytics
   - Market insights

### Phase 3 (Year 2+)

1. **International Expansion**
   - Multi-currency support
   - International buyers
   - Cross-border compliance

2. **API Marketplace**
   - Public API for third parties
   - Developer portal
   - API monetization

3. **Carbon Offset Calculator**
   - For businesses
   - Integration with accounting software
   - Automated purchasing

---

## Support & Documentation

- **Developer Docs:** docs.greenxchange.in
- **API Reference:** api.greenxchange.in/docs
- **Support:** support@greenxchange.in
- **GitHub:** github.com/greenxchange365

---

**Last Updated:** December 2024  
**Version:** 1.0  
**Maintained by:** GreenXchange Technical Team
