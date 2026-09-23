# Cashify Clone — Enterprise ReCommerce & Doorstep Repairs Platform

An enterprise-grade, end-to-end Cashify Clone platform built with **Flutter 3.35** (Mobile & Web Frontend), **FastAPI 0.115+** (Asynchronous Python Backend), **PostgreSQL 16**, **Redis 7**, and an **Autonomous 7-Agent AI Swarm** (Gemini 2.5 Flash / Pro).

---

## 📁 Repository Directory Structure

```
├── lib/                           # 📱 FLUTTER FRONTEND APPLICATION (Mobile & Web)
│   ├── core/                      # Design tokens, themes, widgets, validators
│   │   ├── constants/             # App & API constants
│   │   ├── theme/                 # AppColors, AppSpacing, AppTypography, AppTheme
│   │   ├── utils/                 # CurrencyFormatter, Luhn 15-digit IMEI validator
│   │   └── widgets/               # AppButton, AppTextField, AppCard, BadgePill, CustomAppBar
│   ├── features/                  # Feature Modules (Clean Architecture + Riverpod)
│   │   ├── auth/                  # OTP, Google, Apple, Email, Guest, Hive local token storage
│   │   ├── home/                  # Banner sliders, category grid, trending sell, live search
│   │   ├── sell/                  # Sell flow, 16 automated diagnostics, AI quote, pickup scheduler
│   │   ├── buy/                   # Certified refurbished store, compare tool, wishlist
│   │   ├── cart/                  # Cart with 1-Year ADP warranty, promo coupons, checkout
│   │   ├── repair/                # Doorstep repair issues, 15% combo discount, live GPS tracking
│   │   ├── wallet/                # Cashify wallet, instant IMPS/UPI withdrawal modal, passbook
│   │   ├── referral/              # Referral code RAHUL500, stats, WhatsApp share, leaderboard
│   │   ├── notifications/         # Category filters, unread badges, deep linking
│   │   ├── orders/                # Unified orders tracker across Sell, Buy, and Repair
│   │   ├── profile/               # KYC verified account, saved addresses management
│   │   └── support/               # 24/7 AI Support Chatbot (Agent 6) with human escalation
│   ├── routes/                    # GoRouter 14 with 5-tab persistent stateful navigation shell
│   └── main.dart                  # Flutter entry point
│
├── web/                           # 🌐 FLUTTER WEB RUNNER & MANIFEST
│   ├── index.html                 # Flutter Web entry point
│   └── manifest.json              # PWA manifest
│
├── backend/                       # ⚡ FASTAPI BACKEND & AI MULTI-AGENT SWARM
│   ├── app/
│   │   ├── agents/                # 7 Autonomous AI Agents Swarm
│   │   │   ├── supervisor.py      # Supervisor & Router Agent
│   │   │   ├── pricing_agent.py   # Agent 1: Dynamic Market Valuation Engine
│   │   │   ├── diagnostics_agent.py # Agent 2: 16 Hardware Tests & Spoof Detector
│   │   │   ├── fraud_agent.py     # Agent 3: GSMA Blacklist & Stolen Phone Shield
│   │   │   ├── repair_agent.py    # Agent 4: Smart Parts & 15% Combo Discount Estimator
│   │   │   ├── recommendation_agent.py # Agent 5: Refurbished Trade-in Matchmaker
│   │   │   ├── support_agent.py   # Agent 6: Customer Support & Human Escalation
│   │   │   └── notification_agent.py # Agent 7: Omnichannel Push/WhatsApp/SMS Alerts
│   │   ├── api/v1/                # 100+ REST API Endpoints (/auth, /sell, /buy, /repair, /agents)
│   │   ├── core/                  # Config, SQLAlchemy 2.0 Async, Redis, Security
│   │   ├── models/                # 40+ PostgreSQL Database Tables
│   │   ├── schemas/               # Pydantic v2 schemas
│   │   ├── static/index.html      # 💻 Standalone Web Client (Runs in browser without Flutter!)
│   │   └── main.py                # FastAPI Application & Lifespan
│   ├── tests/                     # Pytest suite for all 7 AI agents (8/8 passed)
│   ├── Dockerfile                 # Production backend container
│   ├── docker-compose.yml         # FastAPI + PostgreSQL 16 + Redis 7 + Celery stack
│   └── requirements.txt           # Python dependencies
│
├── PRD.md                         # 25+ functional modules, 69 Flutter screens sitemap
├── design-system.md               # Material 3 design tokens, typography, colors, 8px grid
├── architecture.md                # Clean Architecture, Riverpod, DB schemas, API specs
└── agents.md                      # AI Multi-Agent Swarm specifications & mathematical formulas
```

---

## 🚀 How to Run

### Option 1: Run the Web Client Instantly (No Flutter Needed)
The backend includes a standalone, fully-featured interactive Web Client matching the Flutter UI:
```bash
cd backend
python -m venv venv
venv\Scripts\activate   # Or source venv/bin/activate on Linux/Mac
pip install -r requirements.txt
python run_server.py
```
Open **[http://localhost:8000](http://localhost:8000)** in your browser!
- **Interactive Swagger Docs:** `http://localhost:8000/api/v1/docs`
- **ReDoc API Reference:** `http://localhost:8000/api/v1/redoc`

---

### Option 2: Run the Flutter Mobile App
Requires [Flutter SDK 3.35+](https://flutter.dev):
```bash
# In the repository root:
flutter pub get
flutter run
```

---

### Option 3: Run with Docker Compose
```bash
cd backend
docker-compose up -d --build
```
This launches FastAPI, PostgreSQL 16, Redis 7, and Celery Worker automatically.

---

## 🧪 Testing the AI Agents Swarm
```bash
cd backend
pytest tests/test_agents.py -v
```
All 8 test suites pass with a 100% success rate:
- `test_pricing_agent_valuation_deductions`
- `test_diagnostics_agent_spoofing_detection`
- `test_fraud_agent_blacklisted_gsma`
- `test_repair_cost_combo_discount`
- `test_recommendation_trade_in_effective_price`
- `test_customer_support_human_escalation`
- `test_notification_omnichannel_routing`
- `test_supervisor_orchestration_blocking_stolen_imei`