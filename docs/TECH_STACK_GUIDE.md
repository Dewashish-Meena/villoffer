# Technology Stack Guide - City Offers Marketplace

## Overview

This guide provides technology recommendations specifically tailored for a **solo developer** building with **zero budget**. Every recommendation prioritizes:

1. ✅ Free hosting and tools
2. ✅ Single-language consistency (when possible)
3. ✅ Large community support
4. ✅ Fast development speed
5. ✅ Long-term maintainability

---

## Final Recommended Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                    MOBILE APPLICATION                            │
├─────────────────────────────────────────────────────────────────┤
│ Framework: Flutter (Dart)                                       │
│ - Single codebase for Android & iOS                             │
│ - Excellent performance                                         │
│ - Large community, great documentation                          │
│ - Free tier hosting via Vercel                                   │
│ Learning Curve: Medium (2-4 weeks to proficiency)              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    ADMIN CONSOLE (Web)                           │
├─────────────────────────────────────────────────────────────────┤
│ Framework: React.js + TypeScript                                │
│ - Modern, maintainable codebase                                 │
│ - Rich ecosystem of UI components                               │
│ - Easy integration with mobile backend                          │
│ - Free hosting on Vercel                                        │
│ Learning Curve: Medium (if you know JS)                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND API                                   │
├─────────────────────────────────────────────────────────────────┤
│ Runtime: Node.js + Express.js (JavaScript)                      │
│ - JavaScript everywhere (mobile + web consistency)              │
│ - Fast development speed                                        │
│ - Excellent free hosting options                                │
│ - Built-in authentication libraries                             │
│ Learning Curve: Low-Medium                                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE                                      │
├─────────────────────────────────────────────────────────────────┤
│ Database: PostgreSQL (via Supabase)                             │
│ - Relational structure fits well                                │
│ - Free hosting included with Supabase                           │
│ - Excellent performance for this use case                       │
│ - ACID compliance                                               │
│ Learning Curve: Low-Medium                                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    MAPS INTEGRATION                              │
├─────────────────────────────────────────────────────────────────┤
│ Service: OpenStreetMap + Leaflet.js                             │
│ - Completely free and open-source                               │
│ - No API keys required                                          │
│ - Works well for local searches                                 │
│ Learning Curve: Low                                             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    HOSTING                                       │
├─────────────────────────────────────────────────────────────────┤
│ Frontend (Mobile Web): Vercel                                   │
│ Backend API: Render or Railway                                  │
│ Database: Supabase                                              │
│ File Storage: Cloudinary (free tier)                            │
│ Push Notifications: Firebase Cloud Messaging                    │
│ Total Monthly Cost: $0                                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Detailed Technology Breakdown

### 1. Mobile Application: Flutter

#### Why Flutter?
| Advantage | Benefit for You |
|-----------|-----------------|
| Single codebase | Write once, deploy to both Android and iOS |
| Hot reload | See changes instantly while coding |
| Native performance | Smooth animations, fast execution |
| Large community | Easy to find solutions on Stack Overflow |
| Excellent docs | Official Flutter documentation is comprehensive |
| Free & open-source | No licensing costs |

#### Learning Resources (Free)
- **Official Docs**: flutter.dev/docs
- **YouTube**: "Flutter Tutorials for Beginners" by Fireship
- **Course**: "The Complete Flutter Bootcamp" on freeCodeCamp (4 hours)
- **Practice**: Build 3 small apps before starting this project

#### Initial Setup Commands
```bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
flutter doctor

# Create new Flutter project
flutter create --platforms=android,ios city_offers_mobile

# Navigate to project
cd city_offers_mobile

# Run on emulator/simulator
flutter run

# Build for production
flutter build apk  # Android
flutter build ios  # iOS (requires Mac)
```

#### Project Structure Template
```
city_offers_mobile/
├── android/                  # Android-specific code
│   ├── app/src/main/
│   └── build.gradle
├── ios/                      # iOS-specific code
│   ├── Runner/
│   └── Podfile
├── lib/                     # Dart source code
│   ├── main.dart           # App entry point
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   │   ├── auth/          # Login, register screens
│   │   ├── home/          # Home, search, browse screens
│   │   ├── offers/        # Offer detail, bookmark screens
│   │   ├── profile/       # User profile, settings
│   │   └── retailer/      # Retailer portal (web view)
│   ├── services/           # API calls, Firebase
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── notification_service.dart
│   ├── widgets/            # Reusable UI components
│   └── utils/              # Helper functions
├── pubspec.yaml            # Dependencies
└── README.md
```

#### Essential Flutter Packages (Free)
```yaml
dependencies:
  # HTTP calls to backend API
  http: ^1.1.0
  
  # Local storage (cached data)
  shared_preferences: ^2.2.2
  
  # Image picker for uploads
  image_picker: ^1.0.7
  
  # Geolocation
  geolocator: ^10.1.0
  
  # Push notifications (Firebase)
  firebase_messaging: ^14.7.9
  
  # Date formatting
  intl: ^0.18.1
  
  # Loading indicators
  loading_indicator: ^2.0.3
  
  # Share functionality
  share: ^3.0.3
  
  # Bottom navigation
  flutter_slidable: ^3.0.1  # For swipe actions
```

---

### 2. Admin Console: React.js + TypeScript

#### Why React?
| Advantage | Benefit for You |
|-----------|-----------------|
| Large ecosystem | Thousands of pre-built components |
| Hot module replacement | Instant feedback while coding |
| Vercel integration | One-click deployment |
| TypeScript support | Catch errors before runtime |
| Great learning resources | Most tutorials available online |

#### Learning Resources (Free)
- **Official Docs**: react.dev (new, beginner-friendly)
- **Course**: "React for Beginners" on freeCodeCamp
- **Component Library**: shadcn/ui (free, copy-paste components)
- **State Management**: Redux Toolkit or Zustand

#### Initial Setup Commands
```bash
# Create React app with Vite (faster than create-react-app)
npm create vite@latest admin-portal -- --template react-ts

# Navigate to project
cd admin-portal

# Install dependencies
npm install

# Add essential packages
npm install react-router-dom axios framer-motion date-fns
npm install @headlessui/react @heroicons/react  # For UI components

# Run development server
npm run dev

# Build for production
npm run build
```

#### Project Structure Template
```
admin-portal/
├── src/
│   ├── components/         # Reusable components
│   │   ├── Layout/        # Sidebar, header, main content
│   │   ├── Forms/         # Form inputs, validators
│   │   ├── Tables/        # Data tables for listings
│   │   └── Charts/        # Analytics charts (Chart.js)
│   │
│   ├── pages/             # Page components
│   │   ├── Login/         # Admin login page
│   │   ├── Dashboard/     # Overview dashboard
│   │   ├── Retailers/     # Approve/reject applications
│   │   ├── Offers/        # Manage offers
│   │   ├── Disputes/      # Handle disputes
│   │   └── Analytics/     # Performance reports
│   │
│   ├── services/          # API integration
│   │   ├── api.ts         # Axios instance
│   │   └── auth.ts        # Authentication logic
│   │
│   ├── hooks/             # Custom React hooks
│   │   ├── useAuth.ts
│   │   └── useOffers.ts
│   │
│   ├── types/             # TypeScript interfaces
│   ├── App.tsx            # Main app component
│   └── main.tsx           # Entry point
├── package.json
├── tsconfig.json
└── README.md
```

#### Essential React Packages (Free)
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "axios": "^1.6.2",
    "framer-motion": "^10.16.4",  // Animations
    "date-fns": "^3.0.6",         # Date formatting
    "recharts": "^2.10.3",        # Charts for analytics
    "@headlessui/react": "^1.7.18",  # UI components
    "@heroicons/react": "^2.1.1"   # Icons
  },
  "devDependencies": {
    "typescript": "^5.3.2",
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.2.0"
  }
}
```

---

### 3. Backend API: Node.js + Express

#### Why Node.js?
| Advantage | Benefit for You |
|-----------|-----------------|
| JavaScript everywhere | Same language as frontend/mobile |
| Fast development | Non-blocking I/O, great for APIs |
| Free hosting | Render, Railway offer generous free tiers |
| Mature ecosystem | Everything available on npm |
| Easy deployment | Simple configuration files |

#### Learning Resources (Free)
- **Official Docs**: nodejs.org/docs
- **Express Guide**: expressjs.com/en/guide/routing.html
- **Course**: "Node.js and Express API" on freeCodeCamp (4 hours)

#### Initial Setup Commands
```bash
# Create project directory
mkdir city_offers_backend
cd city_offers_backend

# Initialize npm
npm init -y

# Install dependencies
npm install express cors dotenv pg bcryptjs jsonwebtoken
npm install @types/express @types/node @types/cors \
  @types/bcryptjs @types/jsonwebtoken --save-dev

# Add development tools
npm install nodemon --save-dev

# Create project structure
mkdir src/{config,controllers,routes,middleware,services,models,utils}

# Start development server
npx nodemon src/index.js
```

#### Project Structure Template
```
city_offers_backend/
├── src/
│   ├── config/            # Configuration files
│   │   └── database.js    # DB connection setup
│   │
│   ├── controllers/       # Route handlers
│   │   ├── authController.js
│   │   ├── userController.js
│   │   ├── retailerController.js
│   │   ├── offerController.js
│   │   └── disputeController.js
│   │
│   ├── routes/            # API endpoints
│   │   ├── index.js       # Main router
│   │   ├── authRoutes.js
│   │   ├── userRoutes.js
│   │   ├── retailerRoutes.js
│   │   └── offerRoutes.js
│   │
│   ├── middleware/        # Middleware functions
│   │   ├── auth.middleware.js    # JWT verification
│   │   ├── admin.middleware.js   # Admin route protection
│   │   ├── validation.middleware.js  # Request validation
│   │   └── errorHandler.js       # Error handling
│   │
│   ├── services/          # Business logic
│   │   ├── authService.js
│   │   ├── retailerService.js
│   │   ├── offerService.js
│   │   └── notificationService.js
│   │
│   ├── models/            # Database models ( Sequelize or raw SQL)
│   │   ├── user.model.js
│   │   ├── retailer.model.js
│   │   └── offer.model.js
│   │
│   ├── utils/             # Helper functions
│   │   ├── logger.js      # Logging utility
│   │   └── emailService.js  # Email sending (optional)
│   │
│   └── index.js           # Entry point
├── .env                   # Environment variables
├── .gitignore
├── package.json
└── README.md
```

#### Essential Backend Packages (Free)
```json
{
  "dependencies": {
    "express": "^4.18.2",           # Web framework
    "cors": "^2.8.5",               # Cross-origin requests
    "dotenv": "^16.3.1",            # Environment variables
    "pg": "^8.11.3",                # PostgreSQL client
    "bcryptjs": "^2.4.3",           # Password hashing
    "jsonwebtoken": "^9.0.2",       # JWT tokens
    "uuid": "^9.0.1"                # UUID generation
  },
  "devDependencies": {
    "nodemon": "^3.0.2",            # Auto-restart on file changes
    "@types/express": "^4.17.21",   # TypeScript types
    "@types/node": "^20.10.5",      # Node.js types
    "@types/cors": "^2.8.17",       # CORS types
    "@types/bcryptjs": "^2.4.6",    # bcrypt types
    "@types/jsonwebtoken": "^9.0.5" # JWT types
  }
}
```

#### Express Server Example (src/index.js)
```javascript
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const authRoutes = require('./src/routes/authRoutes');
const userRoutes = require('./src/routes/userRoutes');
const retailerRoutes = require('./src/routes/retailerRoutes');
const offerRoutes = require('./src/routes/offerRoutes');

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/retailers', retailerRoutes);
app.use('/api/v1/offers', offerRoutes);

// Start server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

---

### 4. Database: PostgreSQL (via Supabase)

#### Why Supabase?
| Advantage | Benefit for You |
|-----------|-----------------|
| Free tier generous | 500MB storage, 50K rows/month |
| PostgreSQL features | All advanced SQL capabilities |
| Auto-hosted | No server management needed |
| API ready | Instant REST and Realtime APIs |
| Easy migrations | CLI for database changes |

#### Learning Resources (Free)
- **Supabase Docs**: supabase.com/docs
- **PostgreSQL Tutorial**: postgresqltutorial.com
- **SQL Practice**: leetcode.com/database

#### Supabase Setup
```bash
# Install Supabase CLI
npm install -g @supabase/supabase-js

# Create project on Supabase dashboard
# Go to: https://supabase.com/dashboard/new

# After setup, you'll get:
# - Project URL (e.g., https://xyz.supabase.co)
# - API Key (anon/public)
# - Service Role Key (for admin operations)
```

#### Database Connection Setup
```javascript
// src/config/database.js
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

module.exports = pool;
```

#### .env File Template
```bash
# Database Configuration
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=city_offers

# Supabase (if using cloud)
SUPABASE_URL=https://xyz.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# JWT Secret (generate with: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
JWT_SECRET=change_this_to_a_secure_random_string

# Firebase Configuration
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=123456789
```

---

### 5. Maps Integration: OpenStreetMap + Leaflet.js

#### Why OpenStreetMap?
| Advantage | Benefit for You |
|-----------|-----------------|
| Completely free | No API keys or costs |
| No rate limits | Unlimited queries |
| Easy to use | Simple JavaScript API |
| Customizable | Style it however you want |
| Open-source | Community-driven improvements |

#### Setup Instructions

**For Mobile App (Flutter):**
```yaml
# pubspec.yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  osm_vector_tile_client: ^0.0.4
```

**For Web Admin Console:**
```html
<!-- Add to your HTML -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

// In your JavaScript
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Create map
const map = L.map('map').setView([23.0225, 72.5714], 13); // Mumbai coordinates

// Add OpenStreetMap tile layer
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
}).addTo(map);

// Add marker
L.marker([23.0225, 72.5714]).addTo(map)
    .bindPopup('Shop Location')
    .openPopup();
```

---

### 6. Hosting Services (All Free Tiers)

#### A. Frontend Hosting: Vercel
- **Free Tier**: Unlimited personal projects, 100GB bandwidth/month
- **Setup**: Connect GitHub repo → Deploy
- **Auto-HTTPS**: Automatic SSL certificates
- **Global CDN**: Fast worldwide delivery

**Deployment Steps:**
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd admin-portal
vercel --prod
```

#### B. Backend Hosting: Render
- **Free Tier**: 750 hours/month (enough for MVP)
- **Setup**: Connect GitHub repo → Add Postgres database
- **HTTPS**: Automatic
- **Environment Variables**: Easy to configure

**Deployment Steps:**
```bash
# Install Render CLI
npm install -g @rendercloud/cli

# Login and deploy
render login
render up
```

#### C. Alternative Backend: Railway
- **Free Tier**: 500 hours/month, generous for small apps
- **Setup**: Similar to Render
- **Better free tier** in some cases

**Deployment:**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway up
```

#### D. Database: Supabase
- **Free Tier**: 500MB storage, unlimited rows, 50K monthly active users
- **Setup**: Dashboard → New Project → Connect to backend
- **Features**: Includes Auth, Storage, Realtime subscriptions

---

### 7. Push Notifications: Firebase Cloud Messaging (FCM)

#### Why FCM?
| Advantage | Benefit for You |
|-----------|-----------------|
| Completely free | Unlimited push notifications |
| Cross-platform | Works on Android and iOS |
| Easy integration | SDKs for Flutter and web |
| Reliable delivery | 99.9% delivery rate |

#### Setup Instructions

**1. Create Firebase Project:**
```bash
# Visit: https://console.firebase.google.com/
# Create new project
# Add Web app and Mobile app
# Download configuration files
```

**2. Flutter Integration:**
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
```

```dart
// services/notification_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    await Firebase.initializeApp();
    
    // Request permission
    await _messaging.requestPermission();
    
    // Get token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('New message: ${message.notification?.title}');
    });
  }
}
```

**3. Backend Integration:**
```javascript
// services/notificationService.js
const admin = require('firebase-admin');
require('dotenv').config();

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
});

async function sendPushNotification(userPhone, title, body, data) {
    const response = await fetch(
        'https://fcm.googleapis.com/v1/projects/your-project-id/messages:broadcast',
        {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${process.env.FCM_SERVER_KEY}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                notification: { title, body },
                data,
                topic: userPhone, // Use phone as topic for targeting
            }),
        }
    );
    
    return response.json();
}
```

---

## Alternative Stack Options

### Option 2: Firebase-First Approach (Even Faster)
If you want to skip backend setup entirely:

| Component | Technology |
|-----------|------------|
| Backend | Firebase Functions |
| Database | Firestore (NoSQL) |
| Auth | Firebase Authentication |
| Storage | Firebase Storage |
| Hosting | Firebase Hosting |

**Pros:** Zero infrastructure management  
**Cons:** Vendor lock-in, costs at scale, less control

### Option 3: Java Spring Boot (As You Mentioned)
Since you mentioned Java/Spring Boot preference:

| Component | Technology |
|-----------|------------|
| Backend | Spring Boot + JPA |
| Database | PostgreSQL |
| Mobile | Kotlin Multiplatform or React Native |
| Frontend | React.js |

**Pros:** Enterprise-grade, great job market skills  
**Cons:** Slower development, steeper learning curve for solo dev

---

## Development Environment Setup (Complete Guide)

### Prerequisites Checklist
- [ ] Node.js 18+ installed ([nodejs.org](https://nodejs.org))
- [ ] Git installed ([git-scm.com](https://git-scm.com))
- [ ] Flutter SDK installed (for mobile)
- [ ] Code editor: VS Code recommended
- [ ] Chrome browser with extensions

### VS Code Extensions (Free)
```json
{
    "extensions": [
        "dart-code.dart-code",           // Flutter/Dart support
        "dbaeumer.vscode-eslint",        // ESLint for JS/TS
        "esbenp.prettier-vscode",        // Code formatting
        "ms-mssql.mssql",                // Database browser
        "mhutchie.git-graph",            // Git visualization
        "bradlc.vscode-tailwindcss"      // If using Tailwind CSS
    ]
}
```

### Local Development Setup

**1. Clone Repository:**
```bash
git clone <your-repo-url>
cd city-offers-marketplace
```

**2. Set Up Backend:**
```bash
cd backend-api
npm install
cp .env.example .env
# Edit .env with your database credentials
npx nodemon src/index.js
```

**3. Set Up Mobile App:**
```bash
cd mobile-app
flutter pub get
flutter run
```

**4. Set Up Admin Console:**
```bash
cd admin-portal
npm install
npm run dev
```

---

## Cost Breakdown (Zero Budget Strategy)

| Service | Free Tier | Your Usage Estimate | Actual Cost |
|---------|-----------|---------------------|-------------|
| Vercel Hosting | Unlimited projects, 100GB bandwidth | ~50 users × 20 pages = 1,000 views | $0 |
| Render/Railway Backend | 750 hours/month | API calls for 100 users | $0 |
| Supabase Database | 500MB storage, 50K rows | < 100K total rows | $0 |
| Cloudinary Images | 25GB storage, unlimited bandwidth | ~100 retailer images | $0 |
| Firebase FCM | Unlimited push notifications | Free tier generous | $0 |
| Domain Name | N/A (use subdomain initially) | Can add later | ~$10/year |

**Total Monthly Cost: $0**

---

## Learning Roadmap (8 Weeks to MVP)

### Week 1-2: Flutter Basics
- [ ] Install Flutter SDK
- [ ] Complete "Flutter for Beginners" tutorial
- [ ] Build a simple todo app
- [ ] Understand state management (Provider)

### Week 3-4: Backend API
- [ ] Learn Express.js basics
- [ ] Set up PostgreSQL with Supabase
- [ ] Create CRUD endpoints for users
- [ ] Implement JWT authentication

### Week 5-6: Mobile Features
- [ ] Build login/register screens
- [ ] Integrate with backend API
- [ ] Create offer listing page
- [ ] Add search and filters

### Week 7-8: Admin Console & Polish
- [ ] Build admin dashboard
- [ ] Implement retailer approval flow
- [ ] Add push notifications
- [ ] Test on real devices
- [ ] Deploy to production

---

## Troubleshooting Common Issues

### Flutter Issues
```bash
# Fix Android build errors
cd android && ./gradlew clean && cd ..

# Fix iOS signing issues (Mac only)
flutter precache --ios

# Clean build cache
flutter clean && flutter pub get
```

### Node.js Issues
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check for outdated packages
npm outdated
```

### Database Issues
```sql
-- Reset database (if stuck)
DROP DATABASE city_offers;
CREATE DATABASE city_offers;

-- Check connection
\conninfo
```

---

## Final Recommendations

### For Maximum Efficiency:
1. **Start with Flutter** - It's the most complex part, tackle first
2. **Use Supabase** - Handles database + Auth in one place
3. **Deploy early** - Get something live after Week 4
4. **Iterate quickly** - Don't perfect features before MVP

### Time Estimates:
- **Learning Flutter**: 20-40 hours
- **Building Backend**: 30-50 hours  
- **Mobile App Features**: 60-80 hours
- **Admin Console**: 40-60 hours
- **Testing & Deployment**: 20-30 hours

**Total: ~170-238 hours (3-5 weeks full-time)**

### When to Get Help:
- If stuck on one issue for > 2 hours, search Stack Overflow first
- Join Flutter Discord community for quick help
- Consider hiring a freelancer for non-critical features later

---

*Tech Stack Guide Version: 1.0*  
*Last Updated: Current Session*  
*Status: Production Ready*
