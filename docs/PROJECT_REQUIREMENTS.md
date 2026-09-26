# City Offers Marketplace - Complete Requirements Document

## Executive Summary
A mobile-first marketplace application connecting local residents with nearby shops offering discounts, promotions, and services. Built as an open-source project for a single developer with zero budget.

---

## 1. Target Market & Scope

### Geographic Focus
- **Initial**: Single residential town (semi-urban, not rural)
- **Future**: Multi-city expansion capability
- **User Base Target**: 100+ daily active users at MVP

### User Personas
1. **End Users** (Consumers)
   - Local residents aged 18-65
   - Looking for deals on groceries, services, retail
   - Mobile-first users with basic smartphone access

2. **Retailers** (Business Owners)
   - Shop owners across categories: groceries, salons, restaurants, retail stores, services, automobiles
   - Need to attract local customers through offers
   - Willing to pay for advertising space

3. **Admin** (You - Developer)
   - Manual approval of retailer onboarding
   - Monitor disputes and offer validity
   - Manage platform revenue

---

## 2. Core Features Breakdown

### MVP MUST-HAVE FEATURES

#### A. User App (Mobile - Android & iOS)

1. **User Authentication**
   - Mobile number registration (OTP-based)
   - No email required initially
   - Simple login with phone verification

2. **Offer Discovery**
   - Search by keyword (specific items/services)
   - Browse by category (groceries, salons, restaurants, retail, services, automobiles)
   - Location-based filtering (nearby shops)
   - Category filters and sorting (newest, popular, discounted)

3. **Offer Details**
   - Shop name, address, contact info
   - Offer description, terms & conditions
   - Discount amount (% or fixed value)
   - Validity period with countdown timer
   - Stock status (available/sold out)
   - Retailer rating and reviews

4. **Offer Interaction**
   - Bookmark/save offers for later
   - Share offers via WhatsApp/SMS/social media
   - "Use Offer" button (manual verification flow)
   - Mark as used successfully (with optional photo proof)

5. **User Profile**
   - Name, phone number
   - Saved/bookmarked offers
   - User reviews and ratings
   - Referral code and stats

6. **Notifications**
   - Push notifications for:
     - New offers in user's area
     - Offers expiring soon
     - Retailer responses to disputes
   - In-app notification center

7. **Referral System**
   - Both referrer and referee get rewards
   - Simple code-based sharing
   - Track referrals in profile

#### B. Retailer Portal (Web Admin Console)

1. **Retailer Registration & Onboarding**
   - Self-registration form:
     - Business name, type, category
     - Owner details (name, phone, email)
     - Shop address with map coordinates
     - Business documents upload (license, registration)
   - Manual admin approval workflow
   - Approval/Rejection notifications via SMS/email

2. **Offer Management**
   - Create multiple offers simultaneously
   - Offer fields:
     - Title and description
     - Discount value (% or fixed)
     - Validity start/end dates
     - Stock limit (quantity-based)
     - Terms & conditions
     - Image upload (offer visual)
   - Edit existing offers
   - Mark as sold out / temporarily unavailable
   - Delete/archived offers

3. **Analytics Dashboard**
   - Total views per offer
   - Redemption count
   - User ratings and feedback
   - Revenue generated (if applicable)
   - Category-wise performance

4. **Offer Status Management**
   - Draft, Pending Approval, Active, Expired, Sold Out
   - Bulk status updates
   - Featured offers selection

5. **Admin Console Features**
   - Approve/reject retailer applications
   - View all users and their activity
   - Dispute management:
     - User reports invalid offers
     - Retailer response mechanism
     - Admin decision logging
   - Content moderation (spam detection)
   - Manual spam flagging based on:
     - Duplicate offer detection
     - Suspicious patterns
     - High complaint ratio

#### C. Public Landing Page
- App download links (Google Play Store)
- Features overview
- Testimonials
- Newsletter signup (optional)
- Contact form for retailer inquiries

---

## 3. Future Features (Post-MVP)

### Phase 2 Enhancements
1. **QR Code Redemption** - Scannable codes at shops
2. **Payment Gateway Integration** - Razorpay/Stripe for secure transactions
3. **Advanced Spam Detection** - ML-based duplicate detection
4. **In-App Chat** - Direct retailer-user communication
5. **Push Notification Customization** - User-controlled preferences
6. **Multi-language Support** - Hindi + English interface
7. **Offline Mode** - Download offers for offline access
8. **Analytics Reports** - Detailed retailer insights
9. **Leaderboard** - Top retailers by redemptions

### Phase 3 (Long-term)
1. **Multi-city Expansion**
2. **Commission-based Revenue Model**
3. **Premium Retailer Tiers**
4. **Loyalty Points System**
5. **Integrated Payment Wallets**
6. **Social Features** - User groups, neighborhood feeds

---

## 4. Monetization Models (Flexible)

### Option A: One-Time Fee per Ad
- Flat ₹XXX per offer post
- Simple, predictable for retailers
- Best for occasional advertisers

### Option B: Subscription Model
- Monthly/quarterly plans
- Unlimited offers within limit
- Better for high-frequency retailers

### Option C: Commission-based
- % of each redemption
- Riskier but performance-aligned
- Requires payment gateway integration

### Hybrid Approach (Recommended)
- Allow retailers to choose their preferred model
- Default to one-time fee initially (easiest to implement)
- Offer subscriptions later as premium tier

---

## 5. Payment Processing Strategy

### Phase 1: Manual DB Storage
- Store retailer payment details securely in database
- Manual reconciliation by admin
- Simple bank transfer tracking
- No third-party integration needed

### Phase 2: Payment Gateway Integration
- Razorpay/Stripe for India (or PayPal for international)
- Automated invoicing
- Real-time transaction tracking
- Secure escrow for disputed offers

---

## 6. Technology Stack Recommendations

### Mobile Applications
**Recommended: Flutter**
- Single codebase for Android & iOS
- Excellent performance
- Large community, good documentation
- Free tier hosting available
- Hot reload for faster development
- Native-like UI components

**Alternative: React Native**
- If you prefer JavaScript ecosystem
- Large library support
- Similar benefits to Flutter

### Admin Console (Web)
**Recommended: React.js + TypeScript**
- Modern, maintainable codebase
- Rich ecosystem of UI components
- Easy integration with mobile backend
- Free hosting on Vercel/Netlify

**Alternative: Java Spring Boot (as you mentioned)**
- Enterprise-grade stability
- Steeper learning curve if unfamiliar
- Good for long-term scalability
- Can host on free tiers (Render, Railway)

### Backend & API
**Recommended: Node.js + Express**
- JavaScript everywhere (mobile + web consistency)
- Fast development speed
- Excellent free hosting options (Render, Railway, Fly.io)
- Built-in authentication libraries

**Alternative: Firebase (Backend-as-a-Service)**
- Zero infrastructure management
- Real-time database capabilities
- Free tier is generous
- May hit limits at 100+ users
- Easier but less flexible long-term

### Database
**Recommended: PostgreSQL**
- Relational data structure fits well
- Free hosting (Neon, Supabase, Railway)
- Excellent performance for this use case
- ACID compliance for transactions

**Alternative: MongoDB**
- Flexible schema for offers
- Easy scaling
- Good free tiers (MongoDB Atlas)

### Maps Integration
**Recommended: OpenStreetMap + Leaflet.js**
- Completely free and open-source
- No API keys required
- Works well for local searches
- Customizable styling

**Alternative: Google Maps Platform**
- Better accuracy but costs money after free tier
- Complex API management
- Not recommended for zero-budget project

### Hosting Strategy (Zero Budget)
- **Frontend**: Vercel or Netlify (free tier generous)
- **Backend**: Render, Railway, or Fly.io (free tiers available)
- **Database**: Supabase (PostgreSQL), Neon, or MongoDB Atlas
- **File Storage**: Cloudinary (images) or AWS S3 free tier
- **Push Notifications**: Firebase Cloud Messaging (free)

---

## 7. Database Schema Design

### Core Tables

#### Users
```sql
id, phone_number, name, email, created_at, 
referral_code, referrals_count, total_referrals_reward,
is_verified, last_login_at
```

#### Retailers
```sql
id, user_id (FK), business_name, category, description,
address, latitude, longitude, contact_phone, contact_email,
status (pending/approved/rejected), documents_path,
rating_avg, total_reviews, created_at, approved_at
```

#### Offers
```sql
id, retailer_id (FK), title, description, discount_type, 
discount_value, image_path, terms_conditions,
latitude, longitude, is_active, stock_limit, sold_count,
validity_start, validity_end, status (draft/published/expired/sold_out),
created_at, updated_at
```

#### Offer_Uses
```sql
id, offer_id (FK), user_id (FK), used_at, verification_status,
verification_proof_path, notes
```

#### Reviews
```sql
id, user_id (FK), target_type (offer/retailer), target_id (FK),
rating, comment, created_at
```

#### Referrals
```sql
id, referrer_id (FK), referee_phone, referred_at, reward_status
```

#### Disputes
```sql
id, offer_id (FK), reporter_id (FK), retailer_response,
status (open/resolved/closed), admin_notes, created_at
```

---

## 8. Development Phases & Timeline

### Phase 1: Foundation (Weeks 1-2)
**Goal**: Core infrastructure and authentication
- Set up repositories (GitHub/GitLab)
- Initialize Flutter mobile app
- Build React admin console skeleton
- Setup backend API structure
- Implement user registration/login (mobile number OTP)
- Create database schema and migrations

### Phase 2: Retailer Onboarding (Weeks 3-4)
**Goal**: Enable retailers to join and create offers
- Complete retailer registration flow
- Document upload and verification UI
- Admin approval dashboard
- Offer creation form with validation
- Basic offer listing page

### Phase 3: User Discovery & Interaction (Weeks 5-6)
**Goal**: Users can browse, search, and use offers
- Search functionality (keyword + category)
- Category browsing with filters
- Location-based filtering
- Offer detail pages
- Bookmark/save functionality
- "Use offer" manual verification flow

### Phase 4: Admin & Analytics (Weeks 7-8)
**Goal**: Complete admin features and analytics
- Retailer dashboard with analytics
- Dispute management system
- Content moderation tools
- Push notification setup
- Basic reporting

### Phase 5: Polish & Testing (Weeks 9-10)
**Goal**: Quality assurance and preparation for launch
- Bug fixing and performance optimization
- Security audit
- User testing with small group
- App store preparation
- Landing page creation

### Phase 6: Launch (Week 11+)
**Goal**: Go live and start user acquisition
- Submit to Google Play Store
- Deploy landing page
- Social media launch
- Initial retailer outreach

---

## 9. Security Considerations

### Data Protection
- Encrypt sensitive data at rest (payment info, personal details)
- HTTPS everywhere (Vercel/Netlify handle this automatically)
- Secure OTP implementation with rate limiting
- Session management for admin console

### Retailer Verification
- Manual document review process
- Phone number verification via OTP
- Address validation
- Periodic re-verification option

### User Data Privacy
- No unnecessary data collection
- Clear privacy policy
- Option to delete account and data
- GDPR/DPDP compliance basics

---

## 10. Risk Assessment & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Low initial adoption | High | Medium | Aggressive marketing, partnerships with local influencers |
| Retailer fraud/fake offers | Medium | Medium | Manual verification, user reporting system, penalties |
| Technical bugs in MVP | Medium | High | Extensive testing, code review, phased rollout |
| Payment disputes | Low | Medium | Clear terms, admin oversight, easy dispute process |
| Server costs at scale | Low | Low | Monitor usage, upgrade only when needed |

---

## 11. Success Metrics (MVP)

### Quantitative
- **User Acquisition**: 500 registered users in first month
- **Retailer Onboarding**: 50 approved retailers
- **Offer Views**: Average 100 views per active offer
- **Redemption Rate**: 10% of viewed offers redeemed
- **Daily Active Users**: 100+ DAU

### Qualitative
- User satisfaction (app store ratings > 4.0)
- Retailer retention (repeat advertisers)
- Dispute resolution time (< 24 hours)
- App performance (< 3s page load times)

---

## 12. Next Steps - Immediate Actions

1. **Choose Tech Stack Finalization**
   - Confirm: Flutter + Node.js + PostgreSQL
   - Create GitHub repositories

2. **Design System Setup**
   - Choose UI component library (Material Design for Flutter)
   - Set up design tokens and color scheme

3. **Database Schema Implementation**
   - Create initial migrations
   - Seed data for testing

4. **Authentication Flow**
   - Implement OTP service integration
   - Build login/register screens

5. **Set Up Development Environment**
   - Local development setup guide
   - CI/CD pipeline basics (GitHub Actions)

---

## 13. Budget & Resource Planning

### Zero-Budget Strategy
- All free tier hosting
- Open-source libraries only
- Self-documentation (no paid tools)
- Community support (Stack Overflow, Discord)

### Estimated Time Investment
- **Development**: 2-3 months full-time
- **Testing**: 1 month part-time
- **Launch & Marketing**: Ongoing

### Potential Costs (Future Scaling)
- App Store developer accounts: $25 Google, $99 Apple (one-time)
- Server upgrades: $20-50/month when needed
- Payment gateway fees: ~2% per transaction
- Domain name: ~$10/year

---

## 14. Open Source Strategy (Private Project)

Since you mentioned this is a private project:
- **Repository**: Private GitHub/GitLab repository
- **License**: No license needed (proprietary)
- **Code Access**: Only you and your team (if any)
- **Documentation**: Internal wiki or README for future reference
- **Maintenance**: Self-maintained long-term

---

## 15. Competitive Analysis & Differentiation

### What Makes This Unique
1. **Hyper-local focus** - Tailored to specific town demographics
2. **Manual verification** - Builds trust through human oversight
3. **Flexible monetization** - Multiple options for retailers
4. **Zero initial cost** - Low barrier to entry
5. **Open architecture** - Can customize and extend easily

### Potential Challenges
1. **Network effect** - Need both users AND retailers simultaneously
2. **Trust building** - Convincing people to use new platform
3. **Content quality** - Ensuring offers are legitimate
4. **Retention** - Keeping users coming back regularly

---

## Appendix A: Feature Priority Matrix

| Feature | User Value | Development Effort | Strategic Importance | Priority |
|---------|-----------|-------------------|---------------------|----------|
| Mobile registration | High | Low | Critical | P0 |
| Offer search/browse | High | Medium | Critical | P0 |
| Offer details page | High | Medium | Critical | P0 |
| Manual offer redemption | Medium | Low | Critical | P0 |
| Retailer onboarding | High | Medium | Critical | P0 |
| Admin approval flow | High | Medium | Critical | P0 |
| Push notifications | Medium | Medium | Important | P1 |
| Referral system | Medium | Medium | Important | P1 |
| Reviews & ratings | Medium | Low | Important | P1 |
| QR code redemption | Low | High | Future | P2 |

---

## Appendix B: Key Decisions Made

✅ **Mobile Platform**: Flutter (single codebase for Android/iOS)  
✅ **Backend**: Node.js + Express (JavaScript consistency)  
✅ **Database**: PostgreSQL (relational, free hosting)  
✅ **Maps**: OpenStreetMap (free, no API keys)  
✅ **Hosting**: Free tiers (Vercel, Render, Supabase)  
✅ **Authentication**: Mobile number OTP  
✅ **Monetization**: One-time fee per ad initially  
✅ **Verification**: Manual document review  
✅ **Redemption**: Manual verification first, QR codes later  
✅ **Languages**: English + Hindi (customizable)  
✅ **Disputes**: Retailer handles, admin oversight  
✅ **Analytics**: Basic dashboard included  

---

*Document Version: 1.0*  
*Last Updated: Current Session*  
*Status: Ready for Development Planning*
