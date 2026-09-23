# System Architecture & API Specification — Cashify Clone
## Enterprise Flutter Mobile Client + FastAPI Backend Architecture

---

### Architecture Specification
- **Version:** 1.0.0 (Production-Grade)
- **Mobile Stack:** Flutter 3.35 (Dart 3.5), Riverpod 2.6, GoRouter 14.x, Dio 5.7, Hive 2.2
- **Backend Stack:** FastAPI 0.115+, Python 3.12+, SQLAlchemy 2.0 (Async), PostgreSQL 16, Redis 7.2, Celery 5.4
- **Cloud & Infrastructure:** AWS (EKS / ECS, S3, RDS PostgreSQL, ElastiCache Redis), Docker, Cloudflare CDN
- **Security:** TLS 1.3, SSL Pinning, JWT (RS256), AES-256 Encrypted Hive, HMAC Payment Verification

---

## 1. High-Level System Architecture

```
                                  ┌──────────────────────────────┐
                                  │      Client Applications     │
                                  │  • Flutter Mobile (iOS/And)  │
                                  │  • Admin Web Dashboard       │
                                  │  • Technician Companion App  │
                                  └──────────────┬───────────────┘
                                                 │
                                           HTTPS / WSS
                                                 │
                                  ┌──────────────▼───────────────┐
                                  │      Cloudflare CDN & WAF    │
                                  │   (DDoS, SSL, Rate Limit)    │
                                  └──────────────┬───────────────┘
                                                 │
                                  ┌──────────────▼───────────────┐
                                  │    AWS Application Load      │
                                  │       Balancer (ALB)         │
                                  └──────────────┬───────────────┘
                                                 │
                                 ┌───────────────┴───────────────┐
                                 ▼                               ▼
                 ┌───────────────────────────────┐ ┌───────────────────────────────┐
                 │    FastAPI API Gateway Node 1 │ │    FastAPI API Gateway Node 2 │
                 │    (Async REST + WebSocket)   │ │    (Async REST + WebSocket)   │
                 └───────────────┬───────────────┘ └───────────────┬───────────────┘
                                 │                                 │
     ┌───────────────────────────┼─────────────────────────────────┼───────────────────────────┐
     ▼                           ▼                                 ▼                           ▼
┌───────────────┐       ┌─────────────────┐               ┌─────────────────┐       ┌─────────────────────┐
│  Redis Cache  │       │  PostgreSQL 16  │               │ Celery Workers  │       │  AI Multi-Agent     │
│  & Pub/Sub    │       │ (Async Primary  │               │ (Async Tasks,   │       │  Cluster            │
│ (Catalog, Rate│       │  & Read Replica)│               │  Notifications, │       │ (Gemini 2.5 Flash / │
│  Sessions)    │       │                 │               │  Invoices)      │       │  Custom Models)     │
└───────────────┘       └─────────────────┘               └─────────────────┘       └─────────────────────┘
                                                                   │
                                 ┌─────────────────────────────────┴───────────────────────────┐
                                 ▼                                 ▼                           ▼
                        ┌─────────────────┐               ┌─────────────────┐       ┌─────────────────────┐
                        │   AWS S3 /      │               │ Payment Gateways│       │ Omnichannel Gateway │
                        │   Cloudinary    │               │ Razorpay /      │       │ Firebase FCM,       │
                        │ (Device Media)  │               │ Cashfree Payout │       │ Twilio, WhatsApp    │
                        └─────────────────┘               └─────────────────┘       └─────────────────────┘
```

---

## 2. Flutter Client Architecture

### 2.1 Directory Structure
The Flutter codebase follows the **Feature-Driven Clean Architecture** pattern:

```
lib/
│
├── core/
│   ├── config/              # App config, environment variables, flavors
│   ├── constants/           # Colors, assets, strings, endpoints, storage keys
│   ├── errors/              # Custom exceptions, failure types, error mapper
│   ├── network/             # Dio client, interceptors, connectivity checker
│   ├── storage/             # Hive boxes, secure storage wrapper, cache manager
│   ├── theme/               # Material 3 light/dark themes, color tokens, text styles
│   ├── utils/               # Currency formatters, Luhn validator, date helpers
│   └── widgets/             # Core reusable UI: buttons, textfields, cards, loaders
│
├── features/
│   ├── auth/                # Login, OTP verification, biometrics, user session
│   ├── home/                # Home dashboard, banner sliders, category grids
│   ├── sell/                # Catalog hierarchy, questionnaires, quote generation
│   ├── diagnostics/         # Automated hardware test engine (touch, audio, camera)
│   ├── buy/                 # Refurbished catalog, filters, details, comparison
│   ├── cart/                # Cart management, warranty upgrades, coupon validator
│   ├── checkout/            # Address selection, Razorpay gateway, order placement
│   ├── repair/              # Repair booking, issue checklist, technician GPS track
│   ├── exchange/            # Trade-in valuation during checkout flow
│   ├── wallet/              # Cashback balance, transaction ledger, withdrawals
│   ├── referral/            # Referral codes, deep linking, gamified rewards
│   ├── notifications/       # Push & in-app alerts center
│   ├── orders/              # Unified tracking for sell, buy, and repair orders
│   └── profile/             # Profile details, addresses, saved payment UPIs
│
├── models/                  # Shared data models (Freezed / JSON Serializable)
├── repositories/            # Data repositories abstracting remote & local sources
├── routes/                  # GoRouter declarative configuration, route guards
└── main.dart                # Application entrypoint, provider scopes, Hive init
```

### 2.2 State Management: Riverpod (v2.6+)
- **AsyncNotifier / Notifier:** Encapsulates business logic, state mutations, and API calls.
- **AutoDispose:** Automatically tears down streams and temporary states (e.g., active diagnostics session).
- **Family Modifiers:** Parameterized queries (e.g., `productDetailProvider(productId)`).
- **Optimistic UI Updates:** State is modified locally immediately for operations like "Add to Wishlist" and "Update Cart Quantity", then synced with the API in the background with rollback handling.

```dart
// Example: Sell Quote Notifier Implementation
@riverpod
class SellQuoteNotifier extends _$SellQuoteNotifier {
  @override
  FutureOr<SellQuoteState> build(String modelId) async {
    return _fetchInitialQuote(modelId);
  }

  Future<void> recalculateQuoteWithDiagnostics({
    required Map<String, dynamic> questionnaireAnswers,
    required List<DiagnosticResult> testResults,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sellRepositoryProvider);
      return await repository.getAiCalculatedQuote(
        modelId: modelId,
        answers: questionnaireAnswers,
        diagnostics: testResults,
      );
    });
  }
}
```

### 2.3 Routing Architecture: GoRouter (v14+)
- **ShellRoute / StatefulShellRoute:** Preserves the state of all 5 tabs (Home, Sell, Buy, Repair, Profile) during bottom navigation switching without rebuilding.
- **Route Guards & Redirects:** Checks auth state from `authNotifierProvider`. Redirects unauthenticated users to `/login` when accessing protected routes (e.g., `/checkout`, `/orders`, `/wallet`).
- **Deep Linking:** Handles deep links for shared products (`cashify://product/:id`) and referrals (`cashify://ref/:code`).

### 2.4 Resilient Networking: Dio + Interceptors
1. **AuthInterceptor:** Injects `Authorization: Bearer <token>` into outgoing requests.
2. **RefreshTokenInterceptor:** Intercepts `401 Unauthorized`. Automatically halts pending requests, calls `/api/v1/auth/refresh`, updates the token in encrypted storage, and replays failed requests.
3. **RetryInterceptor:** Exponential backoff retry (up to 3 attempts) for network timeouts (`502`, `503`, `504`).
4. **OfflineCacheInterceptor:** Delivers cached responses from local Hive storage when device is disconnected.

---

## 3. Backend Stack & Architecture (FastAPI + Async Ecosystem)

### 3.1 Directory Structure
```
backend/
│
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/    # Auth, Sell, Buy, Repair, Wallet, Admin
│   │   │   └── api_router.py # Aggregated API v1 router
│   │   └── deps.py           # Dependency injections (DB session, current_user)
│   │
│   ├── core/
│   │   ├── config.py         # Pydantic Settings (.env, database URLs, API keys)
│   │   ├── security.py       # JWT creation, Argon2 hashing, token verification
│   │   └── database.py       # Async SQLAlchemy sessionmaker & engine
│   │
│   ├── models/               # SQLAlchemy 2.0 declarative database models (40+ tables)
│   ├── schemas/              # Pydantic v2 validation & response schemas
│   ├── crud/                 # CRUD database repositories
│   ├── services/             # Business logic (Payment, Logistics, Price Engine)
│   ├── agents/               # AI Agents (Gemini orchestration, LangChain/LlamaIndex)
│   ├── tasks/                # Celery background tasks (SMS, Email, Invoice PDF)
│   └── utils/                # Helper utilities (Luhn check, invoice generator)
│
├── alembic/                  # Database migration scripts
├── tests/                    # Pytest test suite (Unit & Integration)
├── docker-compose.yml        # PostgreSQL, Redis, FastAPI, Celery, Flower
└── Dockerfile                # Multi-stage production container build
```

---

## 4. Comprehensive Database Schema (40+ PostgreSQL Tables)

### Entity Relationship Architecture

```
  ┌─────────────────────────────────────────────────────────────┐
  │                         CORE IDENTITY                       │
  ├─────────────────────────────────────────────────────────────┤
  │  users ───────┬──< user_sessions                            │
  │               ├──< addresses                                │
  │               ├──< bank_accounts                            │
  │               ├──< wallets ──────< wallet_transactions      │
  │               └──< referrals                                │
  └───────────────┬─────────────────────────────────────────────┘
                  │
  ┌───────────────┴─────────────────────────────────────────────┐
  │                         DEVICE MASTER                       │
  ├─────────────────────────────────────────────────────────────┤
  │  categories ──< brands ──< models ──< variants              │
  │                              │                              │
  │                              └──< condition_questions       │
  │                                        └──< condition_options
  └───────────────┬─────────────────────────────────────────────┘
                  │
  ┌───────────────┴─────────────────────────────────────────────┐
  │                      RE-COMMERCE (SELL)                     │
  ├─────────────────────────────────────────────────────────────┤
  │  sell_orders ─────┬──< sell_order_items                     │
  │                   ├──< diagnostics_sessions ──< test_results│
  │                   ├──< quotes ──< quote_deductions          │
  │                   └──< payouts                              │
  └───────────────┬─────────────────────────────────────────────┘
                  │
  ┌───────────────┴─────────────────────────────────────────────┐
  │                     MARKETPLACE (BUY)                       │
  ├─────────────────────────────────────────────────────────────┤
  │  products ────────┬──< product_images                       │
  │                   ├──< product_qc_reports                   │
  │                   └──< inventory_items                      │
  │  cart ────────────< cart_items                              │
  │  coupons ─────────< coupon_redemptions                      │
  │  orders ──────────┬──< order_items                          │
  │                   └──< payments                             │
  └───────────────┬─────────────────────────────────────────────┘
                  │
  ┌───────────────┴─────────────────────────────────────────────┐
  │                     SERVICES & OPERATIONS                   │
  ├─────────────────────────────────────────────────────────────┤
  │  repairs ─────────┬──< repair_items                         │
  │                   └──< technician_assignments               │
  │  technicians ─────┘                                         │
  │  notifications ───< push_tokens                             │
  │  fraud_flags                                                │
  │  audit_logs                                                 │
  └─────────────────────────────────────────────────────────────┘
```

### Table Definitions & Specifications

#### 1. Identity & Profile
- `users`: `id (UUID, PK)`, `phone (VARCHAR(15), UNIQUE)`, `email (VARCHAR(255), UNIQUE)`, `full_name (VARCHAR(100))`, `avatar_url (TEXT)`, `role (ENUM: customer, technician, admin, qc_agent)`, `is_active (BOOLEAN)`, `is_phone_verified (BOOLEAN)`, `created_at (TIMESTAMPTZ)`, `updated_at (TIMESTAMPTZ)`.
- `user_sessions`: `id (UUID, PK)`, `user_id (FK -> users)`, `refresh_token (VARCHAR(512))`, `device_fingerprint (VARCHAR(255))`, `ip_address (INET)`, `user_agent (TEXT)`, `expires_at (TIMESTAMPTZ)`, `created_at (TIMESTAMPTZ)`.
- `addresses`: `id (UUID, PK)`, `user_id (FK -> users)`, `tag (ENUM: home, work, other)`, `address_line_1 (TEXT)`, `address_line_2 (TEXT)`, `landmark (VARCHAR(255))`, `city (VARCHAR(100))`, `state (VARCHAR(100))`, `pincode (VARCHAR(10))`, `latitude (DECIMAL(10,8))`, `longitude (DECIMAL(11,8))`, `is_default (BOOLEAN)`.
- `bank_accounts`: `id (UUID, PK)`, `user_id (FK -> users)`, `account_holder_name (VARCHAR(150))`, `bank_name (VARCHAR(100))`, `account_number_encrypted (VARCHAR(255))`, `ifsc_code (VARCHAR(15))`, `upi_id (VARCHAR(100))`, `is_verified (BOOLEAN)`.

#### 2. Device Catalog Master
- `categories`: `id (UUID, PK)`, `name (VARCHAR(100))`, `slug (VARCHAR(100), UNIQUE)`, `icon_url (TEXT)`, `display_order (INT)`.
- `brands`: `id (UUID, PK)`, `category_id (FK -> categories)`, `name (VARCHAR(100))`, `logo_url (TEXT)`.
- `models`: `id (UUID, PK)`, `brand_id (FK -> brands)`, `name (VARCHAR(150))`, `image_url (TEXT)`, `release_year (INT)`, `base_price_mrp (DECIMAL(12,2))`.
- `variants`: `id (UUID, PK)`, `model_id (FK -> models)`, `ram_gb (INT)`, `storage_gb (INT)`, `color_name (VARCHAR(50))`, `color_hex (VARCHAR(7))`, `base_resale_value (DECIMAL(12,2))`.
- `device_specs`: `id (UUID, PK)`, `model_id (FK -> models, UNIQUE)`, `processor (VARCHAR(150))`, `display_specs (TEXT)`, `camera_specs (TEXT)`, `battery_specs (TEXT)`, `connectivity_specs (TEXT)`.
- `condition_questions`: `id (UUID, PK)`, `category_id (FK -> categories)`, `question_text (TEXT)`, `step_number (INT)`, `is_required (BOOLEAN)`.
- `condition_options`: `id (UUID, PK)`, `question_id (FK -> condition_questions)`, `option_text (TEXT)`, `deduction_percentage (DECIMAL(5,2))`, `severity (ENUM: none, minor, major, critical)`.

#### 3. Sell Flow & Diagnostics
- `sell_orders`: `id (UUID, PK)`, `order_number (VARCHAR(50), UNIQUE)`, `user_id (FK -> users)`, `address_id (FK -> addresses)`, `status (ENUM: scheduled, assigned, out_for_pickup, verified, paid, cancelled)`, `pickup_slot (TIMESTAMPTZ)`, `pickup_agent_id (FK -> users)`, `final_payout_amount (DECIMAL(12,2))`, `created_at (TIMESTAMPTZ)`.
- `sell_order_items`: `id (UUID, PK)`, `sell_order_id (FK -> sell_orders)`, `variant_id (FK -> variants)`, `imei (VARCHAR(18))`, `quoted_price (DECIMAL(12,2))`.
- `diagnostics_sessions`: `id (UUID, PK)`, `sell_order_item_id (FK -> sell_order_items, NULLABLE)`, `imei (VARCHAR(18))`, `overall_health_score (INT)`, `created_at (TIMESTAMPTZ)`.
- `diagnostic_test_results`: `id (UUID, PK)`, `session_id (FK -> diagnostics_sessions)`, `test_key (VARCHAR(50))`, `status (ENUM: pass, fail, skipped)`, `raw_telemetry (JSONB)`.
- `quotes`: `id (UUID, PK)`, `variant_id (FK -> variants)`, `base_price (DECIMAL(12,2))`, `calculated_price (DECIMAL(12,2))`, `expires_at (TIMESTAMPTZ)`, `confidence_score (DECIMAL(5,2))`.
- `quote_deductions`: `id (UUID, PK)`, `quote_id (FK -> quotes)`, `component_name (VARCHAR(100))`, `deduction_amount (DECIMAL(12,2))`, `reason (TEXT)`.

#### 4. Marketplace (Buy & Inventory)
- `products`: `id (UUID, PK)`, `variant_id (FK -> variants)`, `title (VARCHAR(255))`, `grade (ENUM: superb, good, fair)`, `refurbished_price (DECIMAL(12,2))`, `mrp (DECIMAL(12,2))`, `stock_count (INT)`, `warranty_months (INT, DEFAULT 6)`.
- `product_images`: `id (UUID, PK)`, `product_id (FK -> products)`, `image_url (TEXT)`, `sort_order (INT)`.
- `product_qc_reports`: `id (UUID, PK)`, `product_id (FK -> products)`, `tested_by (FK -> users)`, `passed_checkpoints_count (INT, DEFAULT 32)`, `qc_details (JSONB)`.
- `inventory_items`: `id (UUID, PK)`, `product_id (FK -> products)`, `serial_number (VARCHAR(100), UNIQUE)`, `imei (VARCHAR(18), UNIQUE)`, `warehouse_location (VARCHAR(100))`, `status (ENUM: in_stock, reserved, sold, returned)`.
- `cart`: `id (UUID, PK)`, `user_id (FK -> users, UNIQUE)`, `updated_at (TIMESTAMPTZ)`.
- `cart_items`: `id (UUID, PK)`, `cart_id (FK -> cart)`, `product_id (FK -> products)`, `quantity (INT, DEFAULT 1)`, `warranty_upgrade (BOOLEAN, DEFAULT FALSE)`.
- `coupons`: `id (UUID, PK)`, `code (VARCHAR(50), UNIQUE)`, `discount_type (ENUM: percentage, flat)`, `discount_val (DECIMAL(10,2))`, `min_order_amount (DECIMAL(12,2))`, `max_discount_cap (DECIMAL(10,2))`, `valid_until (TIMESTAMPTZ)`.
- `coupon_redemptions`: `id (UUID, PK)`, `coupon_id (FK -> coupons)`, `user_id (FK -> users)`, `order_id (UUID)`, `redeemed_at (TIMESTAMPTZ)`.
- `orders`: `id (UUID, PK)`, `order_number (VARCHAR(50), UNIQUE)`, `user_id (FK -> users)`, `address_id (FK -> addresses)`, `status (ENUM: placed, packed, shipped, out_for_delivery, delivered, cancelled)`, `subtotal (DECIMAL(12,2))`, `discount_amount (DECIMAL(12,2))`, `total_amount (DECIMAL(12,2))`, `tracking_number (VARCHAR(100))`, `carrier_name (VARCHAR(100))`.
- `order_items`: `id (UUID, PK)`, `order_id (FK -> orders)`, `inventory_item_id (FK -> inventory_items)`, `price (DECIMAL(12,2))`.
- `payments`: `id (UUID, PK)`, `order_id (FK -> orders)`, `gateway (ENUM: razorpay, cashfree, wallet, cod)`, `gateway_transaction_id (VARCHAR(255))`, `amount (DECIMAL(12,2))`, `status (ENUM: pending, authorized, captured, failed, refunded)`.
- `payouts`: `id (UUID, PK)`, `sell_order_id (FK -> sell_orders)`, `user_id (FK -> users)`, `payout_method (ENUM: upi, imps, wallet)`, `reference_id (VARCHAR(255))`, `amount (DECIMAL(12,2))`, `status (ENUM: initiated, success, failed)`.

#### 5. Repair & Services
- `repairs`: `id (UUID, PK)`, `repair_number (VARCHAR(50), UNIQUE)`, `user_id (FK -> users)`, `model_id (FK -> models)`, `address_id (FK -> addresses)`, `status (ENUM: booked, technician_assigned, en_route, in_progress, completed, cancelled)`, `scheduled_slot (TIMESTAMPTZ)`, `total_estimated_cost (DECIMAL(12,2))`.
- `repair_items`: `id (UUID, PK)`, `repair_id (FK -> repairs)`, `service_type (ENUM: screen, battery, camera, speaker, port, mic, back_glass)`, `cost (DECIMAL(10,2))`.
- `technicians`: `id (UUID, PK)`, `user_id (FK -> users, UNIQUE)`, `current_latitude (DECIMAL(10,8))`, `current_longitude (DECIMAL(11,8))`, `is_available (BOOLEAN)`, `rating (DECIMAL(3,2))`.
- `technician_assignments`: `id (UUID, PK)`, `repair_id (FK -> repairs)`, `technician_id (FK -> technicians)`, `status (ENUM: accepted, rejected, completed)`.

#### 6. Wallet, Referral, Operations & Security
- `wallets`: `id (UUID, PK)`, `user_id (FK -> users, UNIQUE)`, `balance (DECIMAL(12,2), DEFAULT 0)`, `currency (VARCHAR(5), DEFAULT 'INR')`.
- `wallet_transactions`: `id (UUID, PK)`, `wallet_id (FK -> wallets)`, `type (ENUM: credit, debit)`, `category (ENUM: cashback, sell_payout, referral_bonus, purchase_split, refund)`, `amount (DECIMAL(12,2))`, `reference_id (VARCHAR(100))`.
- `referrals`: `id (UUID, PK)`, `referrer_user_id (FK -> users)`, `referral_code (VARCHAR(20), UNIQUE)`, `total_referrals_count (INT, DEFAULT 0)`, `total_earned_amount (DECIMAL(12,2), DEFAULT 0)`.
- `referral_rewards`: `id (UUID, PK)`, `referral_id (FK -> referrals)`, `referee_user_id (FK -> users)`, `reward_amount (DECIMAL(10,2))`, `status (ENUM: pending, credited)`.
- `notifications`: `id (UUID, PK)`, `user_id (FK -> users)`, `title (VARCHAR(255))`, `body (TEXT)`, `type (ENUM: order, promotional, security, wallet)`, `action_url (TEXT)`, `is_read (BOOLEAN, DEFAULT FALSE)`.
- `push_tokens`: `id (UUID, PK)`, `user_id (FK -> users)`, `token (TEXT)`, `device_type (ENUM: android, ios)`, `updated_at (TIMESTAMPTZ)`.
- `fraud_flags`: `id (UUID, PK)`, `user_id (FK -> users)`, `imei (VARCHAR(18))`, `risk_score (INT)`, `flag_reason (TEXT)`, `is_resolved (BOOLEAN, DEFAULT FALSE)`.
- `audit_logs`: `id (UUID, PK)`, `user_id (FK -> users)`, `action (VARCHAR(100))`, `entity_type (VARCHAR(50))`, `entity_id (UUID)`, `ip_address (INET)`, `payload (JSONB)`.

---

## 5. Comprehensive REST API Specifications (100+ Endpoints)

### 5.1 Authentication & Profile APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/v1/auth/request-otp` | Sends 6-digit SMS OTP to user's mobile number. |
| `POST` | `/api/v1/auth/verify-otp` | Validates OTP and returns access token + refresh token. |
| `POST` | `/api/v1/auth/google` | Validates Google ID token and returns session tokens. |
| `POST` | `/api/v1/auth/apple` | Validates Apple identity token and authorization code. |
| `POST` | `/api/v1/auth/email/login` | Authenticates via email and password. |
| `POST` | `/api/v1/auth/email/register` | Registers a new email account. |
| `POST` | `/api/v1/auth/refresh` | Exchanges rotating refresh token for a fresh access token. |
| `POST` | `/api/v1/auth/logout` | Revokes the current session and refresh token. |
| `GET` | `/api/v1/profile/me` | Fetches current user profile, wallet balance, and active orders. |
| `PUT` | `/api/v1/profile/me` | Updates name, email, or avatar image. |
| `GET` | `/api/v1/profile/addresses` | Lists all saved delivery/pickup addresses. |
| `POST` | `/api/v1/profile/addresses` | Adds a new address with GPS coordinates. |
| `PUT` | `/api/v1/profile/addresses/{id}` | Edits an existing saved address. |
| `DELETE`| `/api/v1/profile/addresses/{id}` | Deletes an address. |
| `GET` | `/api/v1/profile/bank-accounts` | Lists saved UPI IDs and bank payout accounts. |
| `POST` | `/api/v1/profile/bank-accounts` | Verifies and saves a bank account or UPI ID. |

### 5.2 Device Catalog Master APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/catalog/categories` | Retrieves all device categories with icons. |
| `GET` | `/api/v1/catalog/categories/{id}/brands` | Lists brands within a specific category. |
| `GET` | `/api/v1/catalog/brands/{id}/models` | Lists models under a brand with thumbnail image. |
| `GET` | `/api/v1/catalog/models/{id}/variants` | Lists storage and RAM variants for a model. |
| `GET` | `/api/v1/catalog/models/{id}/specs` | Returns full technical hardware specs. |
| `GET` | `/api/v1/catalog/search` | Full-text predictive search across brands and models. |
| `GET` | `/api/v1/catalog/categories/{id}/questions` | Returns condition questionnaire steps and options. |

### 5.3 Sell Device & Diagnostics APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/v1/sell/validate-imei` | Checks 15-digit IMEI checksum and GSMA blacklist. |
| `POST` | `/api/v1/sell/calculate-quote` | AI valuation calculating instant price from answers & tests. |
| `POST` | `/api/v1/sell/lock-quote` | Locks evaluated quote price for 7 days. |
| `POST` | `/api/v1/sell/diagnostics/session` | Initializes an automated diagnostic test session. |
| `POST` | `/api/v1/sell/diagnostics/{id}/test-result`| Submits hardware test result (pass/fail/telemetry). |
| `GET` | `/api/v1/sell/diagnostics/{id}/summary` | Returns comprehensive diagnostic pass/fail report. |
| `POST` | `/api/v1/sell/orders` | Books doorstep pickup slot with selected payout method. |
| `GET` | `/api/v1/sell/orders/{id}` | Returns pickup order status and live agent assignment. |
| `POST` | `/api/v1/sell/orders/{id}/cancel` | Cancels scheduled pickup. |
| `POST` | `/api/v1/sell/orders/{id}/verify-otp` | Pickup agent inputs customer OTP to complete handover. |

### 5.4 Buy Refurbished & Marketplace APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/marketplace/products` | Paginated catalog with multi-facet filters & sorting. |
| `GET` | `/api/v1/marketplace/products/{id}` | Product details, multi-angle images, 32-point QC cert. |
| `GET` | `/api/v1/marketplace/products/compare` | Compares up to 3 models side-by-side. |
| `GET` | `/api/v1/marketplace/deals` | Retrieves hot promotional deals and discounts. |
| `GET` | `/api/v1/marketplace/wishlist` | Returns user's saved wishlist items. |
| `POST` | `/api/v1/marketplace/wishlist/{product_id}` | Toggles product in/out of wishlist. |
| `GET` | `/api/v1/marketplace/cart` | Fetches active cart items and subtotal. |
| `POST` | `/api/v1/marketplace/cart/items` | Adds item to cart or increments quantity. |
| `PUT` | `/api/v1/marketplace/cart/items/{id}` | Modifies quantity or warranty add-on. |
| `DELETE`| `/api/v1/marketplace/cart/items/{id}` | Removes product from cart. |
| `POST` | `/api/v1/marketplace/coupons/apply` | Validates promo code and applies discount. |
| `DELETE`| `/api/v1/marketplace/coupons/remove` | Removes applied coupon from cart. |
| `POST` | `/api/v1/marketplace/checkout` | Creates order and generates Razorpay payment order. |
| `POST` | `/api/v1/marketplace/payments/verify` | Validates Razorpay HMAC signature and confirms order. |

### 5.5 Repair Services APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/repairs/categories` | Lists repairable device categories. |
| `GET` | `/api/v1/repairs/models/{id}/issues` | Lists repair services and upfront prices for model. |
| `POST` | `/api/v1/repairs/estimate` | Calculates aggregate repair cost for multiple issues. |
| `POST` | `/api/v1/repairs/book` | Confirms doorstep repair booking slot. |
| `GET` | `/api/v1/repairs/orders/{id}` | Returns repair order status and technician assignment. |
| `GET` | `/api/v1/repairs/orders/{id}/tracking` | Real-time GPS coordinates of assigned technician. |
| `POST` | `/api/v1/repairs/orders/{id}/sign-off` | Submits digital checklist and warranty activation. |

### 5.6 Wallet & Referral APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/wallet/balance` | Returns total balance, cashback, and referral credits. |
| `GET` | `/api/v1/wallet/transactions` | Paginated transaction history with filters. |
| `POST` | `/api/v1/wallet/withdraw` | Withdraws available balance to linked bank/UPI. |
| `GET` | `/api/v1/referral/code` | Returns user's referral code and shareable URL. |
| `GET` | `/api/v1/referral/stats` | Earnings, pending invites, and milestone progress. |
| `GET` | `/api/v1/referral/leaderboard` | Top monthly referrers and reward tiers. |

### 5.7 Notifications & Support APIs
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/notifications` | Paginated list of user alerts. |
| `PATCH` | `/api/v1/notifications/{id}/read` | Marks notification as read. |
| `POST` | `/api/v1/notifications/push-token` | Registers Firebase FCM push token for device. |
| `POST` | `/api/v1/support/chat` | Interacts with AI customer support agent. |
