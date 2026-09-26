# Project Architecture

## Overview

City Offers Marketplace is a zero-budget, solo-developer platform connecting local residents with nearby shops offering discounts.

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter (Dart) |
| Retailer Portal | React + TypeScript |
| Admin Console | React + TypeScript |
| Backend API | Node.js + Express |
| Database | PostgreSQL (Supabase) |
| Maps | OpenStreetMap + Leaflet |
| Hosting | Vercel (frontend), Render/Railway (backend), Supabase (DB), Cloudinary (images) |

## Folder Structure

```
city-offers-marketplace/
├── docs/                         # Documentation
├── mobile/                       # Flutter mobile app
├── web/                          # Retailer portal (React)
├── backend/                      # Express API server
└── admin/                        # Admin console (React)
```
