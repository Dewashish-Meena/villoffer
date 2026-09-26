# System Architecture - City Offers Marketplace

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CITY OFFERS MARKETPLACE SYSTEM                       │
└─────────────────────────────────────────────────────────────────────────────┘

                              ┌──────────────┐
                              │   USERS      │  (Mobile App - Flutter)
                              │  (Consumers) │
                              └──────┬───────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
          ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
          │   SEARCH     │  │   BROWSE     │  │   REDeem      │
          │  & FILTER    │  │   OFFERS     │  │   (Manual)   │
          └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
                 │                 │                  │
                 └─────────────────┼──────────────────┘
                                   ▼
                    ┌─────────────────────────────────────┐
                    │         OFFER MANAGEMENT            │
                    │  (Database + API Services)          │
                    └────────────────┬────────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
          ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
          │   RETAILERS  │  │    ADMIN     │  │   NOTIFICATIONS│
          │ (Web Portal) │  │  CONSOLE     │  │   (Firebase)  │
          └──────────────┘  └──────────────┘  └──────────────┘
```

---

## Component Architecture

### 1. Mobile Application (Flutter)

#### A. User Module
```
UserApp/
├── auth/
│   ├── login_screen.dart          # Phone number + OTP entry
│   ├── register_screen.dart       # New user registration
│   ├── otp_verification_service.dart
│   └── session_manager.dart
│
├── home/
│   ├── home_screen.dart           # Main feed with categories
│   ├── search_screen.dart         # Keyword search interface
│   ├── category_list.dart         # Browse by category
│   └── location_filter_dialog.dart
│
├── offers/
│   ├── offer_detail_page.dart     # Individual offer view
│   ├── offer_card.dart            # List item component
│   ├── bookmark_service.dart      # Save/favorite offers
│   └── share_sheet.dart           # Social sharing options
│
├── profile/
│   ├── user_profile_screen.dart   # User details & stats
│   ├── saved_offers_page.dart     # Bookmarked offers
│   ├── referral_screen.dart       # Referral code display
│   └── settings_page.dart         # App preferences
│
├── notifications/
│   ├── notification_list.dart     # In-app notifications
│   └── push_notification_handler.dart
│
└── dispute/
    └── report_offer_dialog.dart   # Flag invalid offers
```

#### B. Retailer Portal (Web - Separate Flutter Web or React)
```
RetailerPortal/
├── auth/
│   └── retailer_login.dart
│
├── dashboard/
│   ├── overview_page.dart         # Analytics summary
│   ├── recent_activity.dart       # Latest actions
│   └── notifications_page.dart    # Admin alerts
│
├── offers/
│   ├── create_offer_form.dart     # Multi-step offer creation
│   ├── edit_offer_form.dart       # Update existing offer
│   ├── offer_list_page.dart       # All retailer offers
│   └── offer_status_management.dart
│
├── analytics/
│   ├── performance_chart.dart     # Views/redemptions graph
│   └── category_breakdown.dart    # Performance by category
│
└── settings/
    └── retailer_profile_edit.dart
```

---

### 2. Backend API (Node.js + Express)

#### A. RESTful Endpoints Structure

```
/api/v1/
├── auth/
│   ├── POST   /register           # User registration
│   ├── POST   /login              # User login
│   ├── POST   /send-otp           # Send verification OTP
│   ├── POST   /verify-otp         # Verify OTP
│   └── GET    /me                 # Get current user profile
│
├── users/
│   ├── GET    /                   # List all users (admin only)
│   ├── GET    /:id                # Get user details
│   ├── PUT    /:id                # Update user profile
│   └── DELETE /:id                # Delete account (admin)
│
├── retailers/
│   ├── POST   /register           # Retailer self-registration
│   ├── GET    /                   # List approved retailers
│   ├── GET    /:id                # Get retailer details
│   ├── PUT    /:id                # Update retailer info
│   ├── DELETE /:id                # Deactivate retailer (admin)
│   └── POST   /:id/documents      # Upload verification docs
│
├── offers/
│   ├── GET    /                   # List all active offers
│   ├── GET    /category/:cat      # Filter by category
│   ├── GET    /search?q=          # Search offers
│   ├── GET    /nearby?lat=&lng=   # Location-based offers
│   ├── POST   /create             # Create new offer (retailer)
│   ├── PUT    /:id                # Update offer
│   ├── DELETE /:id                # Delete offer
│   ├── GET    /:id                # Get single offer details
│   └── PUT    /:id/status         # Update status
│
├── offer-uses/
│   ├── POST   /                   # Mark offer as used
│   ├── GET    /user/:userId       # User's usage history
│   └── GET    /offer/:offerId     # Offer redemption stats
│
├── reviews/
│   ├── POST   /                  # Submit review/rating
│   ├── GET    /offer/:id          # Get offer reviews
│   └── GET    /retailer/:id       # Get retailer reviews
│
├── referrals/
│   ├── GET    /my-stats           # User referral statistics
│   └── POST   /claim-reward       # Claim referral reward
│
├── disputes/
│   ├── POST   /report             # Report invalid offer
│   ├── GET    /:id                # Get dispute details
│   ├── PUT    /:id/respond       # Retailer response
│   └── GET    /pending            # List pending disputes (admin)
│
├── notifications/
│   ├── GET    /                   # User notification list
│   ├── POST   /mark-read          # Mark as read
│   └── POST   /preferences        # Set notification preferences
│
└── admin/
    ├── POST   /retailer/approve  # Approve retailer application
    ├── POST   /retailer/reject   # Reject retailer application
    ├── GET    /disputes          # List all disputes
    ├── PUT    /dispute/:id/close # Close dispute
    ├── GET    /analytics         # Platform-wide analytics
    └── POST   /spam-flag         # Flag content as spam
```

#### B. Service Layer Architecture

```
services/
├── authService.js              # Authentication & session management
├── retailerService.js          # Retailer registration & verification
├── offerService.js             # Offer CRUD operations
├── searchService.js            # Search & filtering logic
├── notificationService.js      # Push notifications (Firebase)
├── disputeService.js           # Dispute handling workflow
├── referralService.js          # Referral tracking & rewards
├── analyticsService.js         # Data aggregation for reports
└── spamDetectionService.js     # Duplicate/spam detection

middleware/
├── auth.middleware.js          # JWT verification
├── admin.middleware.js         # Admin route protection
├── rateLimiter.js              # API rate limiting
├── validation.middleware.js    # Request validation
└── errorHandler.js             # Error handling & logging
```

---

### 3. Database Schema (PostgreSQL)

#### Entity Relationship Diagram

```
┌─────────────┐       ┌──────────────┐       ┌──────────┐
│   USER      │<──────│  RETAILER    │<──────│  ADMIN   │
├─────────────┤       ├──────────────┤       ├──────────┤
│ id (PK)     │       │ id (PK)      │       │ id (PK)  │
│ phone       │       │ user_id (FK) │       │ email    │
│ name        │       │ business_name│       │ name     │
│ created_at  │       │ category     │       │ role     │
└─────────────┘       └──────┬───────┘       └──────────┘
                             │
                             │ (1:N)
                             ▼
                    ┌──────────────────┐
                    │    OFFER         │
                    ├──────────────────┤
                    │ id (PK)          │
                    │ retailer_id (FK) │
                    │ title            │
                    │ description      │
                    │ discount_value   │
                    │ image_path       │
                    │ latitude/longitude│
                    │ stock_limit      │
                    │ sold_count       │
                    │ status           │
                    │ created_at       │
                    └────────┬─────────┘
                             │ (1:N)
                             ▼
                    ┌──────────────────┐
                    │  OFFER_USE       │
                    ├──────────────────┤
                    │ id (PK)          │
                    │ offer_id (FK)    │
                    │ user_id (FK)     │
                    │ used_at          │
                    │ verification_status│
                    └──────────────────┘

                    ┌──────────────────┐       ┌─────────────┐
                    │    REVIEW       │<──────│ DISPUTE      │
                    ├──────────────────┤       ├─────────────┤
                    │ id (PK)          │       │ id (PK)     │
                    │ user_id (FK)     │       │ offer_id (FK)│
                    │ target_type      │       │ reporter_id │
                    │ rating           │       │ status      │
                    │ comment          │       │ created_at  │
                    └──────────────────┘       └─────────────┘

                    ┌──────────────────┐
                    │   REFERRAL       │
                    ├──────────────────┤
                    │ id (PK)          │
                    │ referrer_id (FK) │
                    │ referee_phone    │
                    │ reward_status    │
                    └──────────────────┘
```

#### Detailed Table Structures

##### users
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique user identifier |
| phone_number | VARCHAR(20) | UNIQUE, NOT NULL | Mobile number for login |
| name | VARCHAR(100) | NOT NULL | User's full name |
| email | VARCHAR(100) | Optional | For notifications (optional) |
| referral_code | VARCHAR(10) | UNIQUE, DEFAULT generate_referral() | Referral code |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Account creation time |
| last_login_at | TIMESTAMPTZ | Updated on login | Last login timestamp |
| is_verified | BOOLEAN | DEFAULT false | Phone verification status |

##### retailers
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique retailer identifier |
| user_id | UUID | FOREIGN KEY → users.id | Link to user account |
| business_name | VARCHAR(200) | NOT NULL | Business/shop name |
| category | VARCHAR(50) | NOT NULL | Category (grocery, salon, etc.) |
| description | TEXT | Optional | Business description |
| address | VARCHAR(255) | NOT NULL | Physical address |
| latitude | DECIMAL(10, 8) | For geolocation | Latitude coordinate |
| longitude | DECIMAL(11, 8) | For geolocation | Longitude coordinate |
| contact_phone | VARCHAR(20) | Contact number | Retailer's phone |
| status | VARCHAR(20) | DEFAULT 'pending' | pending/approved/rejected |
| documents_path | TEXT | Document URLs | Verification docs storage |
| rating_avg | DECIMAL(3, 2) | DEFAULT 0.0 | Average user rating |
| total_reviews | INTEGER | DEFAULT 0 | Review count |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Registration time |
| approved_at | TIMESTAMPTZ | On approval | Approval timestamp |

##### offers
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique offer identifier |
| retailer_id | UUID | FOREIGN KEY → retailers.id | Owner of the offer |
| title | VARCHAR(200) | NOT NULL | Offer headline |
| description | TEXT | NOT NULL | Detailed offer description |
| discount_type | VARCHAR(10) | NOT NULL | 'percentage' or 'fixed' |
| discount_value | DECIMAL(10, 2) | NOT NULL | Discount amount |
| image_path | TEXT | Optional | Offer visual |
| terms_conditions | TEXT | Optional | Terms & conditions |
| latitude | DECIMAL(10, 8) | For geolocation | Shop latitude |
| longitude | DECIMAL(11, 8) | For geolocation | Shop longitude |
| is_active | BOOLEAN | DEFAULT true | Offer visibility |
| stock_limit | INTEGER | Optional | Quantity limit |
| sold_count | INTEGER | DEFAULT 0 | Items sold/used |
| status | VARCHAR(20) | DEFAULT 'draft' | draft/published/expired/sold_out |
| validity_start | TIMESTAMPTZ | Offer start date | Start of validity period |
| validity_end | TIMESTAMPTZ | Offer end date | End of validity period |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Creation timestamp |
| updated_at | TIMESTAMPTZ | Updated on change | Last modification time |

##### offer_uses
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique usage record |
| offer_id | UUID | FOREIGN KEY → offers.id | Which offer was used |
| user_id | UUID | FOREIGN KEY → users.id | Who used it |
| used_at | TIMESTAMPTZ | DEFAULT NOW() | When it was used |
| verification_status | VARCHAR(20) | 'pending'/'verified'/'rejected' | Admin/retailer verification |
| verification_proof_path | TEXT | Optional | Photo proof if uploaded |
| notes | TEXT | Optional | Additional notes |

##### reviews
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique review ID |
| user_id | UUID | FOREIGN KEY → users.id | Reviewer |
| target_type | VARCHAR(20) | NOT NULL | 'offer' or 'retailer' |
| target_id | UUID | NOT NULL | What is being reviewed |
| rating | INTEGER | 1-5 scale, NOT NULL | Star rating |
| comment | TEXT | Optional | Written feedback |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Review submission time |

##### disputes
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique dispute ID |
| offer_id | UUID | FOREIGN KEY → offers.id | Disputed offer |
| reporter_id | UUID | FOREIGN KEY → users.id | Who reported it |
| retailer_response | TEXT | Optional | Retailer's reply |
| status | VARCHAR(20) | DEFAULT 'open' | open/resolved/closed |
| admin_notes | TEXT | Optional | Admin decision notes |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Dispute creation time |
| resolved_at | TIMESTAMPTZ | On resolution | Resolution timestamp |

##### referrals
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique referral record |
| referrer_id | UUID | FOREIGN KEY → users.id | Who referred |
| referee_phone | VARCHAR(20) | The new user's phone | New user contact |
| referred_at | TIMESTAMPTZ | When referral happened | Timestamp |
| reward_status | VARCHAR(20) | 'pending'/'claimed'/'failed' | Reward status |

---

## 4. Data Flow Diagrams

### A. User Registration Flow

```
User enters phone number
         │
         ▼
┌─────────────────┐
│ Generate OTP    │ (Backend: Send SMS/WhatsApp)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ User receives   │ (Firebase Cloud Messaging / Twilio)
│ and enters OTP  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Verify OTP      │ (Backend: Check token validity)
└────────┬────────┘
         │
         ├────── Valid ──────┐
         ▼                   │
┌─────────────────┐          │
│ Create User     │◄─────────┘
│ Account         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Send Welcome    │ (Push notification)
│ Notification    │
└─────────────────┘
```

### B. Offer Creation Flow (Retailer)

```
Retailer logs into admin console
         │
         ▼
┌─────────────────┐
│ Create New      │
│ Offer Form      │
└────────┬────────┘
         │
         ├────── Fill Details ──────┐
         ▼                          │
┌─────────────────┐                 │
│ Upload Images   │                 │
│ & Documents     │                 │
└────────┬────────┘                 │
         │                         │
         ▼                         │
┌─────────────────┐                │
│ Save as Draft   │                │
│ OR              │                │
│ Publish Now     │                │
└────────┬────────┘                │
         │                        │
         ├────── Published ───────┤
         ▼                        │
┌─────────────────┐               │
│ Notify Users    │◄──────────────┘
│ (Push Alert)    │
└─────────────────┘
```

### C. Offer Redemption Flow

```
User browses offers
         │
         ▼
┌─────────────────┐
│ Select Offer    │
│ Details Page    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Click "Use      │
│ Offer" Button   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Mark as Used    │ (Create offer_use record)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Visit Shop      │
│ (Manual         │
│ Verification)   │
└────────┬────────┘
         │
         ├────── Successful ──────┐
         ▼                        │
┌─────────────────┐               │
│ Show "Thank     │               │
│ You" Message    │               │
│ + Retailer      │               │
│ Notified        │               │
└─────────────────┘               │
                                  │
         └────── Failed ──────────┘
         ▼
┌─────────────────┐
│ Show Error/     │
│ Request Report  │
└─────────────────┘
```

### D. Retailer Approval Flow

```
Retailer registers on website
         │
         ▼
┌─────────────────┐
│ Submit Business │
│ Details + Docs  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Status: Pending │ (Admin review queue)
└────────┬────────┘
         │
         ├────── Admin Reviews ──────┐
         ▼                           │
┌─────────────────┐                  │
│ Approve OR      │◄─────────────────┤
│ Reject          │                  │
└────────┬────────┘                  │
         │                          │
         ├────── Approved ──────────┤
         ▼                          │
┌─────────────────┐                 │
│ Retailer Can    │                 │
│ Create Offers   │                 │
│ + Send          │                 │
│ Notifications   │                 │
└─────────────────┘                 │
                                    │
         └────── Rejected ──────────┘
         ▼
┌─────────────────┐
│ Email/SMS       │
│ Rejection Reason│
└─────────────────┘
```

---

## 5. Infrastructure Architecture

### Deployment Topology

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLOUD INFRASTRUCTURE                        │
└─────────────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────────┐
│                    FRONTEND (Static Hosting)                       │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              Vercel / Netlify                                │ │
│  │  ───────────────────────────────────────────────────────── │ │
│  │  • Mobile App Web Version                                   │ │
│  │  • Admin Console                                           │ │
│  │  • Landing Page                                            │ │
│  │  Auto-SSL, CDN, Global Edge Locations                       │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
                                │
                    HTTP/HTTPS Requests
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────┐
│                      BACKEND API (Serverless)                      │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                 Render / Railway                             │ │
│  │  ───────────────────────────────────────────────────────── │ │
│  │  • Node.js + Express API                                    │ │
│  │  • RESTful Endpoints                                        │ │
│  │  • WebSockets (optional for real-time)                      │ │
│  │  Environment Variables: DB_URL, FIREBASE_KEY               │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
                                │
                    Database Queries / API Calls
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                                │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              Supabase (PostgreSQL)                          │ │
│  │  ───────────────────────────────────────────────────────── │ │
│  │  • User Data                                                │ │
│  │  • Offers & Retailers                                       │ │
│  │  • Analytics Storage                                        │ │
│  │  Row-Level Security (RLS)                                   │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │            Cloudinary / AWS S3                              │ │
│  │  ───────────────────────────────────────────────────────── │ │
│  │  • Offer Images                                             │ │
│  │  • Document Uploads                                         │ │
│  │  • Profile Pictures                                         │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
                                │
                    Push Notifications / Events
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────┐
│                   NOTIFICATION SERVICE                             │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              Firebase Cloud Messaging                       │ │
│  │  ───────────────────────────────────────────────────────── │ │
│  │  • Push Notifications to Mobile Apps                        │ │
│  │  • In-App Notifications                                     │ │
│  │  • Email Notifications (via SendGrid/Ses)                  │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

### Free Tier Resource Allocation

| Service | Free Tier Limit | Expected Usage (MVP) |
|---------|-----------------|---------------------|
| Vercel Hosting | 100GB bandwidth/month | ~50 users × 20 pages = 1,000 page views |
| Render Backend | 750 hours/month | API calls for 100 users |
| Supabase DB | 500MB storage, 50K rows | Well within limits for MVP |
| Cloudinary Images | 25GB storage, unlimited bandwidth | ~100 retailer images |
| Firebase FCM | Unlimited push notifications | Free tier generous |

---

## 6. Security Architecture

### Authentication & Authorization

```
┌─────────────────────────────────────────────────────────────────┐
│                    SECURITY LAYER                                │
└─────────────────────────────────────────────────────────────────┘

1. User Authentication
   ┌─────────────────────────────────────────────┐
   │ • JWT Tokens (expires in 24h)               │
   │ • Refresh Tokens (stored securely)          │
   │ • Rate Limiting: 5 requests/minute/IP       │
   │ • OTP Expiry: 5 minutes                     │
   └─────────────────────────────────────────────┘

2. API Security
   ┌─────────────────────────────────────────────┐
   │ • HTTPS Everywhere (automatic on Vercel)   │
   │ • CORS Configuration                        │
   │ • Input Validation & Sanitization           │
   │ • SQL Injection Prevention                  │
   │ • XSS Protection                            │
   └─────────────────────────────────────────────┘

3. Data Protection
   ┌─────────────────────────────────────────────┐
   │ • Sensitive Data Encryption (at rest)       │
   │ • Password Hashing (bcrypt)                 │
   │ • Document Upload Scanning                  │
   │ • Session Management                        │
   └─────────────────────────────────────────────┘

4. Admin Access Control
   ┌─────────────────────────────────────────────┐
   │ • Role-Based Access Control (RBAC)          │
   │ • Audit Logging for Admin Actions           │
   │ • IP Whitelisting (optional)                │
   │ • Two-Factor Authentication                 │
   └─────────────────────────────────────────────┘
```

### Threat Model & Mitigation

| Threat | Impact | Likelihood | Mitigation Strategy |
|--------|--------|------------|---------------------|
| Fake retailer offers | Medium | High | Manual verification + user reports |
| Spam registrations | Low | Medium | Rate limiting + phone verification |
| Data breach | High | Low | Encryption, minimal data collection |
| API abuse | Medium | Medium | Rate limiting, input validation |
| SQL injection | High | Low | Parameterized queries, ORM |

---

## 7. Scalability Considerations

### Current Design (MVP - 100 users)
- Single Node.js server instance
- PostgreSQL single database
- No caching layer needed
- Simple file storage

### Future Scaling Paths

#### Phase 2: 1,000+ Users
```
┌─────────────────────────────────────────────┐
│   Horizontal Scaling                        │
│                                             │
│   Load Balancer                             │
│   ├── Node.js Instance 1                    │
│   ├── Node.js Instance 2                    │
│   └── Node.js Instance 3                    │
│                                             │
│   Redis Cache (for sessions, hot data)      │
└─────────────────────────────────────────────┘
```

#### Phase 3: 10,000+ Users
```
┌─────────────────────────────────────────────┐
│   Microservices Architecture                │
│                                             │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│   │ Auth     │  │ Offers   │  │ Users    │ │
│   │ Service  │  │ Service  │  │ Service  │ │
│   └──────────┘  └──────────┘  └──────────┘ │
│                                             │
│   ┌──────────┐  ┌──────────┐                │
│   │ Notifs   │  │ Analytics│                │
│   │ Service  │  │ Service  │                │
│   └──────────┘  └──────────┘                │
└─────────────────────────────────────────────┘
```

---

## 8. Performance Targets

### API Response Times (95th percentile)
| Endpoint | Target Time | Current Expectation |
|----------|-------------|---------------------|
| User Login/Register | < 2s | ~1-2s |
| Get Offers List | < 1s | ~0.5s |
| Create Offer | < 3s | ~2s |
| Search Offers | < 2s | ~1s |
| Upload Image | < 5s (depends on file size) | ~3-4s |

### Mobile App Performance
- App Launch: < 3s
- Page Load: < 2s
- API Calls: < 1s each
- Image Loading: Cached after first load

---

## 9. Monitoring & Observability

### Key Metrics to Track

```javascript
// Analytics Events (Firebase/PostHog)
{
  event: 'offer_viewed',
  properties: {
    offer_id,
    user_id,
    source: 'search' | 'category' | 'notification',
    category
  }
}

{
  event: 'offer_redeemed',
  properties: {
    offer_id,
    user_id,
    retailer_id,
    success: true/false
  }
}

{
  event: 'retailer_registered',
  properties: {
    status: 'approved' | 'rejected',
    time_to_approve_hours
  }
}

{
  event: 'dispute_created',
  properties: {
    offer_id,
    resolution_time_hours
  }
}
```

### Error Tracking
- Log all 5xx errors to monitoring service (Sentry free tier)
- Track API latency > 2s as warning
- Monitor database connection pool usage

---

## 10. Development Workflow

### Git Repository Structure

```
city-offers-marketplace/
├── mobile-app/                 # Flutter mobile application
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── models/            # Data models
│   │   ├── services/          # API calls, Firebase
│   │   ├── screens/           # UI screens
│   │   └── utils/             # Helper functions
│   ├── pubspec.yaml
│   └── README.md
│
├── admin-portal/              # React web admin console
│   ├── src/
│   │   ├── components/        # Reusable UI components
│   │   ├── pages/             # Page components
│   │   ├── services/          # API integration
│   │   └── hooks/             # Custom React hooks
│   ├── package.json
│   └── README.md
│
├── backend-api/               # Node.js + Express API
│   ├── src/
│   │   ├── controllers/       # Route handlers
│   │   ├── models/            # Database models
│   │   ├── routes/            # API endpoints
│   │   ├── services/          # Business logic
│   │   ├── middleware/        # Auth, validation, etc.
│   │   └── utils/             # Helper functions
│   ├── package.json
│   └── README.md
│
├── database/                  # Database schema & migrations
│   ├── migrations/            # SQL migration files
│   └── seeds/                 # Initial seed data
│
├── docs/                      # Documentation
│   ├── api-docs.md
│   ├── architecture.md
│   └── deployment-guide.md
│
└── README.md                  # Project overview
```

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on: [push]

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: cd backend-api && npm install
      - name: Run tests
        run: cd backend-api && npm test

  deploy-frontend:
    needs: test-backend
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          git-token: ${{ secrets.GITHUB_TOKEN }}
          working-directory: admin-portal
```

---

*Architecture Document Version: 1.0*  
*Last Updated: Current Session*  
*Status: Ready for Implementation*
