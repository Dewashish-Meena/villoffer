# Database Schema Implementation Guide

## Overview

This document provides the complete SQL schema for the City Offers Marketplace application. The schema is designed for PostgreSQL and includes all tables, indexes, constraints, and relationships needed for MVP development.

---

## Complete SQL Schema

```sql
-- ============================================================================
-- CITY OFFERS MARKETPLACE - DATABASE SCHEMA
-- PostgreSQL 14+ Compatible
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- ENUM TYPES
-- ============================================================================

-- Retailer verification status
CREATE TYPE retailer_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);

-- Offer status
CREATE TYPE offer_status AS ENUM (
    'draft',
    'published',
    'expired',
    'sold_out'
);

-- Verification status for offer usage
CREATE TYPE verification_status AS ENUM (
    'pending',
    'verified',
    'rejected'
);

-- Dispute status
CREATE TYPE dispute_status AS ENUM (
    'open',
    'in_review',
    'resolved',
    'closed'
);

-- Referral reward status
CREATE TYPE referral_reward_status AS ENUM (
    'pending',
    'claimed',
    'failed'
);

-- Offer discount type
CREATE TYPE discount_type AS ENUM (
    'percentage',
    'fixed'
);

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- ---------------------------------------------------------------------------
-- USERS TABLE
-- Stores all user accounts (consumers and retailers)
-- ---------------------------------------------------------------------------
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Contact information
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    
    -- Referral system
    referral_code VARCHAR(10) UNIQUE DEFAULT ('REF-' || uuid_generate_v4()::TEXT::CHAR(10)),
    
    -- Account status
    is_verified BOOLEAN DEFAULT false,
    is_deleted BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ
    
);

-- Index for phone number lookups
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ---------------------------------------------------------------------------
-- RETAILERS TABLE
-- Stores retailer/business information
-- ---------------------------------------------------------------------------
CREATE TABLE retailers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Link to user account
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Business information
    business_name VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN (
        'grocery', 'salon', 'restaurant', 'retail', 
        'services', 'automobile'
    )),
    description TEXT,
    
    -- Location data
    address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Contact information
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    
    -- Verification status
    status retailer_status DEFAULT 'pending',
    
    -- Documents for verification
    documents_path TEXT[],
    
    -- Analytics
    rating_avg DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    approved_at TIMESTAMPTZ
    
);

-- Indexes for common queries
CREATE INDEX idx_retailers_status ON retailers(status);
CREATE INDEX idx_retailers_category ON retailers(category);
CREATE INDEX idx_retailers_location ON retailers(latitude, longitude);
CREATE INDEX idx_retailers_user_id ON retailers(user_id);

-- Trigger for updated_at
CREATE TRIGGER update_retailers_updated_at
    BEFORE UPDATE ON retailers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ---------------------------------------------------------------------------
-- OFFERS TABLE
-- Stores all offers/promotions created by retailers
-- ---------------------------------------------------------------------------
CREATE TABLE offers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Ownership
    retailer_id UUID NOT NULL REFERENCES retailers(id) ON DELETE CASCADE,
    
    -- Offer details
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    discount_type discount_type NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL CHECK (discount_value >= 0),
    
    -- Media and terms
    image_path TEXT,
    terms_conditions TEXT,
    
    -- Location for nearby filtering
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Stock management
    is_active BOOLEAN DEFAULT true,
    stock_limit INTEGER,
    sold_count INTEGER DEFAULT 0,
    
    -- Status lifecycle
    status offer_status DEFAULT 'draft',
    
    -- Validity period
    validity_start TIMESTAMPTZ,
    validity_end TIMESTAMPTZ,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_offers_retailer ON offers(retailer_id);
CREATE INDEX idx_offers_status ON offers(status);
CREATE INDEX idx_offers_category ON offers(retailers(category));
CREATE INDEX idx_offers_location ON offers(latitude, longitude);
CREATE INDEX idx_offers_validity_end ON offers(validity_end);

-- Partial index for active published offers (most queried)
CREATE INDEX idx_offers_active_published 
    ON offers(status, retailers(category))
    WHERE status = 'published' AND is_active = true;

-- Trigger for updated_at
CREATE TRIGGER update_offers_updated_at
    BEFORE UPDATE ON offers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ---------------------------------------------------------------------------
-- OFFER_USES TABLE
-- Tracks when users redeem/use an offer
-- ---------------------------------------------------------------------------
CREATE TABLE offer_uses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationship to offer and user
    offer_id UUID NOT NULL REFERENCES offers(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Usage details
    used_at TIMESTAMPTZ DEFAULT NOW(),
    verification_status verification_status DEFAULT 'pending',
    
    -- Optional proof and notes
    verification_proof_path TEXT,
    notes TEXT
);

-- Indexes for analytics queries
CREATE INDEX idx_offer_uses_offer ON offer_uses(offer_id);
CREATE INDEX idx_offer_uses_user ON offer_uses(user_id);
CREATE INDEX idx_offer_uses_created ON offer_uses(used_at DESC);

-- Unique constraint: One use per user per offer (prevent double redemption)
CREATE UNIQUE INDEX idx_offer_uses_unique_per_user_offer 
    ON offer_uses(offer_id, user_id);


-- ---------------------------------------------------------------------------
-- REVIEWS TABLE
-- User ratings and feedback for offers and retailers
-- ---------------------------------------------------------------------------
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Who wrote the review
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- What is being reviewed
    target_type VARCHAR(20) NOT NULL CHECK (target_type IN ('offer', 'retailer')),
    target_id UUID NOT NULL,
    
    -- Rating content
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for review queries
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_target_type ON reviews(target_type);
CREATE INDEX idx_reviews_target_id ON reviews(target_type, target_id);

-- Trigger for updated_at
CREATE TRIGGER update_reviews_updated_at
    BEFORE UPDATE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ---------------------------------------------------------------------------
-- DISPUTES TABLE
-- Tracks disputes between users and retailers
-- ---------------------------------------------------------------------------
CREATE TABLE disputes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationship to offer
    offer_id UUID NOT NULL REFERENCES offers(id) ON DELETE CASCADE,
    
    -- Reporter information
    reporter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Dispute content
    retailer_response TEXT,
    admin_notes TEXT,
    
    -- Status workflow
    status dispute_status DEFAULT 'open',
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for dispute management
CREATE INDEX idx_disputes_offer ON disputes(offer_id);
CREATE INDEX idx_disputes_status ON disputes(status);
CREATE INDEX idx_disputes_created ON disputes(created_at DESC);

-- Trigger for timestamps
CREATE TRIGGER update_disputes_updated_at
    BEFORE UPDATE ON disputes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- ---------------------------------------------------------------------------
-- REFERRALS TABLE
-- Tracks user referrals and reward claims
-- ---------------------------------------------------------------------------
CREATE TABLE referrals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Who did the referring
    referrer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- The referee
    referee_phone VARCHAR(20) NOT NULL,
    
    -- Timestamps and status
    referred_at TIMESTAMPTZ DEFAULT NOW(),
    reward_status referral_reward_status DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for referral tracking
CREATE INDEX idx_referrals_referrer ON referrals(referrer_id);
CREATE INDEX idx_referrals_phone ON referrals(referee_phone);


-- ============================================================================
-- ADMIN & INTERNAL TABLES (Optional - Can be simplified)
-- ============================================================================

-- ---------------------------------------------------------------------------
-- ADMIN USERS TABLE
-- Stores admin account credentials (separate from regular users)
-- ---------------------------------------------------------------------------
CREATE TABLE admins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Admin credentials
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    
    -- Admin details
    name VARCHAR(100),
    role VARCHAR(50) DEFAULT 'admin' CHECK (role IN ('admin', 'moderator')),
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ,
    
    -- Account status
    is_active BOOLEAN DEFAULT true
);

CREATE INDEX idx_admins_email ON admins(email);


-- ============================================================================
-- VIEW: Active Offers by Category (for fast browsing)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_active_offers_by_category AS
SELECT 
    o.id,
    o.title,
    o.description,
    o.discount_type,
    o.discount_value,
    o.image_path,
    o.validity_start,
    o.validity_end,
    r.business_name,
    r.category,
    r.address,
    r.latitude,
    r.longitude,
    r.rating_avg,
    COUNT(ou.id) FILTER (WHERE ou.verification_status = 'verified') AS total_redemptions,
    EXTRACT(DAY FROM (NOW() - o.created_at)) AS days_active
FROM offers o
JOIN retailers r ON o.retailer_id = r.id
LEFT JOIN offer_uses ou ON o.id = ou.offer_id AND ou.verification_status = 'verified'
WHERE o.status = 'published' 
    AND o.is_active = true
    AND (o.validity_end IS NULL OR o.validity_end > NOW())
GROUP BY o.id, r.business_name, r.category, r.address, r.latitude, r.longitude, r.rating_avg;


-- ============================================================================
-- VIEW: Retailer Performance Dashboard
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_retailer_performance AS
SELECT 
    r.id,
    r.business_name,
    r.category,
    r.status,
    COUNT(DISTINCT o.id) AS total_offers,
    COUNT(DISTINCT CASE WHEN o.status = 'published' THEN o.id END) AS published_offers,
    COUNT(DISTINCT ou.id) FILTER (WHERE ou.verification_status = 'verified') AS total_redemptions,
    AVG(r.rating_avg) FILTER (WHERE r.total_reviews > 0) AS avg_rating,
    r.total_reviews,
    EXTRACT(DAY FROM (NOW() - r.created_at)) AS days_since_registration
FROM retailers r
LEFT JOIN offers o ON r.id = o.retailer_id
LEFT JOIN offer_uses ou ON o.id = ou.offer_id AND ou.verification_status = 'verified'
GROUP BY r.id, r.business_name, r.category, r.status, r.rating_avg, r.total_reviews, r.created_at;


-- ============================================================================
-- FUNCTIONS & PROCEDURES
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Function: Generate unique referral code
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION generate_referral_code()
RETURNS VARCHAR(10) AS $$
DECLARE
    code TEXT;
BEGIN
    LOOP
        code := 'REF-' || uuid_generate_v4()::TEXT::CHAR(10);
        IF NOT EXISTS (SELECT 1 FROM users WHERE referral_code = code) THEN
            RETURN code;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------------
-- Function: Update user's total referrals count
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_referrals_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users 
    SET referrals_count = (
        SELECT COUNT(*) FROM referrals WHERE referrer_id = NEW.referrer_id
    )
    WHERE id = NEW.referrer_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add referrals_count column to users table if not exists
ALTER TABLE users ADD COLUMN IF NOT EXISTS referrals_count INTEGER DEFAULT 0;


-- ---------------------------------------------------------------------------
-- Function: Update retailer rating average
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_retailer_rating()
RETURNS TRIGGER AS $$
DECLARE
    new_avg DECIMAL(3, 2);
BEGIN
    IF NEW.target_type = 'retailer' THEN
        SELECT AVG(rating) INTO new_avg
        FROM reviews
        WHERE target_type = 'retailer' AND target_id = NEW.target_id;
        
        UPDATE retailers
        SET rating_avg = COALESCE(new_avg, 0.00),
            total_reviews = (
                SELECT COUNT(*) FROM reviews 
                WHERE target_type = 'retailer' AND target_id = NEW.target_id
            )
        WHERE id = NEW.target_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------------
-- Function: Auto-expire old offers
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION auto_expire_offers()
RETURNS VOID AS $$
BEGIN
    UPDATE offers
    SET status = 'expired'
    WHERE status = 'published'
        AND validity_end IS NOT NULL
        AND validity_end < NOW();
END;
$$ LANGUAGE plpgsql;

-- Schedule this to run daily (can be done via cron or background job)


-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Trigger for dispute resolution timestamp
CREATE TRIGGER update_disputes_resolved_at
    BEFORE UPDATE ON disputes
    FOR EACH ROW
    WHEN (OLD.status != 'resolved' AND NEW.status = 'resolved')
    EXECUTE FUNCTION update_disputes_updated_at();


-- ============================================================================
-- INITIAL SEED DATA (For Testing)
-- ============================================================================

-- Insert test admin user (password: admin123 - hash this properly in production!)
INSERT INTO admins (email, password_hash, name, role) VALUES 
    ('admin@cityoffers.local', '$2b$10$examplehash...', 'System Admin', 'admin');

-- Insert sample categories for reference
CREATE TABLE category_reference (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

INSERT INTO category_reference (name, description) VALUES
    ('grocery', 'Grocery stores and supermarkets'),
    ('salon', 'Beauty salons and barbershops'),
    ('restaurant', 'Restaurants and cafes'),
    ('retail', 'Retail shops and boutiques'),
    ('services', 'Professional services'),
    ('automobile', 'Auto repair and services');


-- ============================================================================
-- INDEXES SUMMARY
-- ============================================================================

-- Performance-critical indexes:
-- 1. users(phone_number) - Login lookups
-- 2. retailers(status, category) - Retailer filtering
-- 3. offers(status, retailers(category)) - Active offer browsing (partial index)
-- 4. offers(latitude, longitude) - Location-based queries
-- 5. offer_uses(offer_id, user_id) - Prevent duplicate redemptions
-- 6. disputes(status) - Dispute management
-- 7. reviews(target_type, target_id) - Rating calculations

-- ============================================================================
-- DATABASE SIZE ESTIMATES (MVP Phase)
-- ============================================================================

-- Expected row counts at MVP (100 daily active users):
-- users: ~500 rows
-- retailers: ~50 rows
-- offers: ~200 rows (4 per retailer on average)
-- offer_uses: ~500 rows (2.5% redemption rate)
-- reviews: ~300 rows
-- disputes: ~10-20 rows
-- referrals: ~50 rows

-- Estimated storage: < 50MB total (well within free tier limits)


-- ============================================================================
-- BACKUP & MAINTENANCE PROCEDURES
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Procedure: Full database backup
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION full_database_backup()
RETURNS VOID AS $$
DECLARE
    backup_file TEXT;
BEGIN
    -- Create timestamped backup filename
    backup_file := 'backup_' || TO_CHAR(NOW(), 'YYYYMMDD_HH24MISS') || '.sql';
    
    -- Execute pg_dump (run from command line, not in function)
    -- Command: pg_dump -h localhost -U postgres -d city_offers > backup_YYYYMMDD_HH24MISS.sql
    RAISE NOTICE 'Backup file: %', backup_file;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- SECURITY NOTES
-- ============================================================================

/*
1. Always use parameterized queries to prevent SQL injection
2. Enable PostgreSQL row-level security for sensitive tables
3. Encrypt sensitive data at rest (passwords, payment info)
4. Use SSL/TLS for all database connections
5. Regular vacuum and analyze for performance
6. Monitor connection pool usage
7. Set appropriate pg_hba.conf authentication rules
*/

-- Example: Enable Row Level Security on sensitive tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE disputes ENABLE ROW LEVEL SECURITY;

-- Example RLS policy (adjust based on your auth system):
CREATE POLICY "Users can view their own data" ON users
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);


-- ============================================================================
-- PERFORMANCE TUNING FOR MVP
-- ============================================================================

/*
1. Run VACUUM ANALYZE weekly
2. Monitor slow query log
3. Set work_mem appropriately for query complexity
4. Consider connection pooling if scaling up
5. Archive old data after 90 days if needed
*/


-- ============================================================================
-- SCHEMA VERSION HISTORY
-- ============================================================================

/*
Version 1.0 (Initial MVP Schema)
- Core tables: users, retailers, offers, offer_uses, reviews, disputes, referrals
- Views for analytics and active offers
- Basic triggers and functions
- Indexes for common queries

Future versions will add:
- Payment tracking table
- Notification preferences table
- Advanced spam detection flags
- Multi-city support fields
*/


-- ============================================================================
-- DEPLOYMENT CHECKLIST
-- ============================================================================

/*
Before deploying to production:

1. Remove all test/seed data
2. Set is_deleted = false for all users (or implement soft delete properly)
3. Generate proper password hashes for admin accounts
4. Enable SSL certificates on database connection
5. Configure pg_hba.conf for production security
6. Set up automated daily backups
7. Monitor initial queries and adjust indexes if needed
8. Test disaster recovery procedures
9. Document all custom functions and triggers
10. Set appropriate logging levels

PostgreSQL configuration recommendations:
- shared_buffers: 256MB (for small instances)
- effective_cache_size: 768MB
- maintenance_work_mem: 64MB
- checkpoint_completion_target: 0.9
- wal_buffers: 16MB
*/


-- ============================================================================
-- END OF SCHEMA
-- ============================================================================

```

---

## Implementation Notes for Solo Developer

### Quick Start Commands

```bash
# Create database
psql -U postgres -c "CREATE DATABASE city_offers;"

# Connect and run schema
psql -U postgres -d city_offers -f schema.sql

# Or using psql with heredoc
psql -U postgres -d city_offers << 'EOF'
-- Paste entire schema here
EOF

# Verify tables created
\dt+
```

### Migration Strategy

For future schema changes, use a migration system:

```bash
# Recommended: Use Flyway or Liquibase
# Or simple versioned SQL files in /database/migrations/

# Example migration file: 001_add_payment_table.sql
-- Migration: Add payment tracking table
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    -- ... schema
);
```

### Database Size Monitoring

```sql
-- Check database size
SELECT 
    pg_size_pretty(pg_database_size('city_offers')) as database_size;

-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Monitor slow queries
SELECT * FROM pg_stat_statements 
WHERE calls > 0 
ORDER BY total_exec_time DESC 
LIMIT 10;
```

---

*Database Schema Version: 1.0*  
*Last Updated: Current Session*  
*Status: Production Ready (with modifications)*
