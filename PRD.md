# Product Requirements Document (PRD)
## Cashify Clone — Enterprise Electronics Re-Commerce & Care Platform

---

### Document Control
- **Product Name:** Cashify Clone Mobile & Backend Marketplace
- **Document Version:** 1.0.0 (Production-Grade)
- **Target Release:** Q1 2026
- **Platforms:** iOS & Android (Flutter 3.35+), Web & Admin Dashboard, Backend (FastAPI + PostgreSQL + Redis)
- **Status:** Approved / Ready for Engineering

---

## 1. Executive Summary & Product Vision

### 1.1 Product Vision
To build India's premier circular electronics economy and re-commerce ecosystem where consumers and businesses can seamlessly:
1. **Sell** pre-owned smartphones, laptops, tablets, and smart wearables with zero friction, instant algorithmic quotes, automated hardware diagnostics, and guaranteed doorstep pickup within 24 hours.
2. **Buy** certified refurbished electronics backed by 32-point inspection certificates, 6-to-12-month warranties, 7-day hassle-free replacement, and flexible payment options (EMI/UPI/Cards).
3. **Exchange** existing devices seamlessly at checkout with instant valuation trade-ins.
4. **Repair** gadgets on-demand via certified mobile technicians right at customer doorsteps or through secure courier logistics.
5. **Purchase** verified accessories, power solutions, and protection plans.
6. **Earn & Save** through a digital cashback wallet, gamified referral system, and loyalty rewards.

### 1.2 Core Value Propositions
| Stakeholder | Key Pain Point Solved | Value Proposition |
| :--- | :--- | :--- |
| **Sellers (Consumers)** | Low trade-in offers, unsafe classified meetings, delayed payments | Instant AI valuation, doorstep pickup, instant bank transfer/UPI payout. |
| **Buyers** | Trust issues with second-hand electronics, fear of defects | 32-point QC certification, comprehensive warranty, easy returns. |
| **Repair Seekers** | High OEM repair costs, untrusted local repair shops, long turnarounds | Transparent pricing, doorstep repairs within 60 mins, genuine spare parts. |
| **Refurbishers / Partners**| Fragmented supply chain, manual valuation errors | Scalable diagnostics engine, automated grading, centralized inventory. |

---

## 2. Target Audience & User Personas

### 2.1 Persona 1: Tech-Savvy Upgrade Seekers (Kavita, 27, Software Engineer)
- **Goal:** Wants to upgrade to the latest iPhone every September by selling her 1-year-old device at maximum market value.
- **Needs:** Rapid diagnostic tests, instant bank transfer at the doorstep, no haggling.
- **Pain Point:** Lack of time to meet buyers on peer-to-peer marketplaces; fear of payment fraud.

### 2.2 Persona 2: Budget-Conscious Students (Rahul, 21, College Student)
- **Goal:** Needs a high-spec laptop or flagship phone for studies and gaming under ₹25,000.
- **Needs:** Certified refurbished device with genuine warranty, no-cost EMI, and clear grading (Fair, Good, Superb).
- **Pain Point:** Cannot afford brand-new retail prices; scared of buying defective phones without warranty.

### 2.3 Persona 3: On-Demand Urgent Repair Users (Amit, 34, Marketing Manager)
- **Goal:** Cracked phone screen 2 hours before a major travel flight.
- **Needs:** Doorstep technician who can replace the screen in 45 minutes using certified tools.
- **Pain Point:** Local shops require leaving the device for 3 days; fear of data theft.

### 2.4 Persona 4: Field Technicians & Pickup Agents (Suresh, 29, Delivery & QC Agent)
- **Goal:** Execute assigned pickups, verify device hardware via companion diagnostic app, confirm purchase price, and release payout.
- **Needs:** Fast offline verification, real-time route optimization, instant OTP confirmation.

---

## 3. Business Model & Revenue Streams

1. **Re-Commerce Arbitrage Margins:** Buying pre-owned electronics at algorithmically optimized prices, refurbishing them, and reselling at 20–35% gross margins.
2. **Repair Services:** Revenue from parts and doorstep labor fees (35–45% margin on spare parts and technician logistics).
3. **Exchange Partnerships:** Commission on trade-ins facilitated for OEM and retail e-commerce partners.
4. **Accessories & Add-ons:** High-margin sales of chargers, cases, screen guards, extended warranties, and accidental damage protection (ADP).
5. **Logistics & Convenience Fees:** Express 2-hour doorstep pickup or priority technician dispatch fees.

---

## 4. Comprehensive Functional Modules (25+ Modules)

### Module 01: Authentication & Identity Management
- **Phone OTP Login:** SMS delivery via Firebase Auth / Twilio with auto-read OTP support.
- **Social Login:** Google Sign-In and Apple Sign-In (mandatory for iOS App Store compliance).
- **Email & Password Authentication:** Argon2-hashed passwords with forgot password reset links.
- **Guest Browsing:** Allows unrestricted catalog browsing and price estimation; enforces auth upon initiating sell, repair, or checkout.
- **Biometric Security:** Local biometric authentication (Face ID / Fingerprint) to unlock saved payment cards, wallet transactions, and profile data.
- **JWT Session Architecture:** Short-lived access tokens (15 minutes) with rotating refresh tokens (30 days) stored securely in encrypted platform keystores (iOS Keychain / Android Keystore via Hive AES).

### Module 02: Dynamic Home & Discovery Engine
- **Hero Banner Slider:** Marketing carousels with deep-linking to promotional categories, sales, or seasonal buyback boosters.
- **Quick Action Grid:** Instant access to `Sell Phone`, `Buy Refurbished`, `Book Repair`, `Exchange`, `Accessories`, and `Find Stores`.
- **Top Selling Devices:** Dynamic feed of highest-volume devices with live "Trending Buyback Price".
- **Refurbished Hot Deals:** Carousel displaying limited-stock refurbished flagships with discount badges and warranty tags.
- **Recent Searches & Location Switcher:** Auto-detects user city/pincode to filter localized inventory and technician availability.

### Module 03: Sell Device — Catalog & Spec Hierarchy
- Multi-step interactive hierarchy:
  1. Category (Smartphone, Laptop, Tablet, Smartwatch, Gaming Console, Earbuds).
  2. Brand (Apple, Samsung, OnePlus, Xiaomi, Realme, Google, Dell, HP, etc.).
  3. Model series and exact model name.
  4. Variant (RAM / Storage capacity configuration).
  5. Colorway and regional variant selection.
- Search-first shortcut: Predictive search bar allowing users to jump directly to their exact device (e.g., "iPhone 14 Pro 128GB Space Black").

### Module 04: Sell Device — Device Information & IMEI Verification
- **IMEI Extraction & Input:** Manual 15-digit input or camera barcode scanner (`*#06#`).
- **Luhn Algorithm Validation:** Client-side mathematical validation of IMEI checksum before API dispatch.
- **GSMA Blacklist & Stolen Database Integration:** Checks against carrier blacklists to prevent fraudulent stolen device ingestion.
- **Warranty Status & Age:** Bill availability, warranty duration left (under 3 months, 3-6 months, 6-11 months, out of warranty).
- **Accessories Presence:** Original box, original charger/cable, valid VAT invoice.

### Module 05: Sell Device — Condition Questionnaire
Structured multi-criteria questionnaire assessing cosmetic and functional wear:
1. **Screen Condition:** Flawless (no scratches), Minor scratches (barely visible), Heavy scratches, Cracked glass / Dent on glass, Display touch failure or lines/spots.
2. **Body & Housing Condition:** Pristine / Like New, Minor scratches, Multiple dents/cracks, Bent chassis.
3. **Functional Deficiencies Checklist:**
   - Front / Rear Camera malfunctioning.
   - Battery health (<80% or service alert).
   - Speaker / Receiver cracking or mute.
   - Microphone not recording audio.
   - Biometrics (Face ID / Touch ID) defective.
   - Wi-Fi / Bluetooth / Mobile Network connectivity issues.
   - Physical buttons (Power, Volume) unresponsive.
   - Device subjected to liquid damage or water submersion.

### Module 06: Sell Device — Automated Hardware Diagnostics Suite
A proprietary 16-test automated device diagnostic engine executing native hardware validation:
1. **Multi-Touch Test:** Full screen touch matrix grid; tiles turn green as user swipes over them.
2. **Dead Pixel & Screen Burn Test:** Flashes primary colors (Red, Green, Blue, White, Black) for visual burn-in verification.
3. **Front & Rear Camera Test:** Captures test frames, checks autofocus, and validates camera sensor feeds.
4. **Flashlight Test:** Toggles LED torch and verifies light emission.
5. **Microphone & Audio Loopback Test:** Records 3 seconds of user speech and plays it back to verify mic fidelity and speaker output.
6. **Earpiece Test:** Emits high-frequency tone through proximity-triggered earpiece.
7. **Proximity Sensor Test:** Detects hand waving within 5cm of front top sensor.
8. **Accelerometer & Gyroscope Test:** Real-time 3-axis motion detection tilt test.
9. **Vibration Motor Test:** Triggers haptic motor patterns for user confirmation.
10. **Wi-Fi & Bluetooth Radios:** Scans active SSIDs and Bluetooth peripherals to verify RF transceivers.
11. **GPS Geolocation Test:** Validates GNSS fix and coordinates accuracy within 10 meters.
12. **Battery Health Diagnostics:** Reads OS-level battery health percentage, cycle counts, and charging voltage state.
13. **Biometric Sensors:** Verifies fingerprint hardware response and TrueDepth / Face unlock modules.

### Module 07: AI Price Valuation Engine & Instant Quote
- Instant quotation generation leveraging the **Pricing AI Agent**.
- Considers historical refurbished resale rates, depreciation curves, seasonal demand, cosmetic deductions, and diagnostic test results.
- Price Breakdown: Shows Base Value, Deduction breakdown for defective components, and Accessory Bonus.
- Quote Lock Guarantee: User can lock the price for 7 days with a single tap.

### Module 08: Doorstep Pickup Scheduling & Logistics
- **Address Management:** Pin drop on Google Maps, house/flat number, landmark, street address.
- **Time Slot Selection:** Morning (9 AM - 12 PM), Afternoon (12 PM - 3 PM), Evening (3 PM - 7 PM), or Express (within 2 hours).
- **Payment Method Selection:** UPI (Google Pay, PhonePe, Paytm), Instant IMPS Bank Transfer, or Cashify Wallet with 5% bonus.
- **Order Tracking:** Real-time pickup agent tracking on map with live ETA.
- **Doorstep Verification OTP:** Secure handshake between agent and customer before handover.

### Module 09: Buy Refurbished — Product Catalog & Filters
- Certified inventory categorised by grade:
  - **Superb (Like New):** Zero scratches, battery health >85%, tested 32 checkpoints.
  - **Good:** Barely noticeable hairline micro-scratches, fully functional.
  - **Fair:** Visible cosmetic scratches or minor dents, priced at massive discounts, 100% functionally sound.
- Advanced Faceted Filters: Brand, Price Range, RAM, Internal Storage, Battery Health, Screen Size, 5G Capability, Color, Grade.
- Sorting Options: Price (Low to High / High to Low), Popularity, Discount Percentage, Newest Additions.

### Module 10: Buy Refurbished — Product Details & Specifications
- High-resolution multi-angle photography of certified devices.
- Detailed 32-point inspection report card attached to every individual serial number.
- Technical specs sheet (Processor, Display type, Camera sensors, Battery capacity, OS update eligibility).
- Warranty assurance details: 6-month or 12-month doorstep replacement/repair guarantee.
- Financial options: No-cost EMI calculator (Bajaj Finserv, ZestMoney, Credit Cards) with monthly breakdown.
- Delivery timeline estimation based on delivery pincode.

### Module 11: Device Comparison Engine
- Side-by-side comparison of up to 3 devices simultaneously.
- Direct spec-by-spec comparison highlighting differences in display refresh rate, chipset performance, camera megapixels, and refurbished price delta.

### Module 12: Wishlist & Favorites
- One-tap saving of refurbished items to user wishlist.
- Real-time price-drop push notifications and restock alerts.

### Module 13: Shopping Cart & Intelligent Checkout
- Cart persistence across sessions using local Hive caching and cloud synchronization.
- Coupon and promo-code validation engine with instant discount application.
- Warranty upgrade options (Add 1-year accidental & liquid damage protection).
- Step-by-step checkout: Shipping Address -> Delivery Speed -> Payment Gateway -> Order Confirmation.

### Module 14: Payment Gateway Integration
- **Razorpay Integration:** Full support for UPI intent (GPay, PhonePe, Paytm, BHIM), Credit/Debit cards (Visa, MasterCard, RuPay), NetBanking (50+ banks), and Cardless EMI.
- **Cash on Delivery (COD):** Available for select pincodes with verification OTP.
- **Cashify Wallet Payment:** Split-payment option (Wallet balance + Razorpay for remainder).

### Module 15: Exchange Device Flow (Trade-In at Purchase)
- User selects refurbished device to buy.
- Selects "Exchange Old Device" option on the product page.
- Selects old phone brand, model, condition, and gets instant trade-in value deducted directly from cart total.
- Single delivery: Delivery partner delivers refurbished device and evaluates old phone on the spot.

### Module 16: Doorstep Repair Services Catalog
- Repair categories: Smartphone, Laptop, Tablet, Smartwatch.
- Issue Selector:
  - Cracked Screen / Display Touch Replacement.
  - Battery Replacement (OEM certified).
  - Charging Port Repair.
  - Camera Lens & Sensor Repair.
  - Mic & Speaker Overhaul.
  - Back Panel Glass Replacement.
  - Motherboard / IC Level Repair.
- Instant transparent pricing upfront with 6-month warranty on repaired parts.

### Module 17: Repair Booking & Live Technician Tracking
- Customer selects repair service, device model, and doorstep location.
- Live slot selection with technician assignment.
- Real-time GPS map tracking showing technician en route to customer location.
- In-app repair checklist: Before-repair test -> Repair execution -> After-repair validation with customer sign-off.

### Module 18: Electronics Accessories Marketplace
- Curated store for premium certified accessories:
  - Fast chargers (GaN 30W/65W/100W), braided Type-C & Lightning cables.
  - Tempered glass screen protectors with alignment trays.
  - Shockproof cases and MagSafe accessories.
  - TWS earbuds, noise-canceling headphones, smart bands.

### Module 19: Digital Wallet & Cashback
- **Cashback Credits:** Earned on selling devices or promo campaigns.
- **Refunds Balance:** Instant refund deposit for cancelled or returned orders.
- **Referral Bonus:** Withdrawable cash bonus earned from inviting peers.
- Transaction history with downloadable monthly balance statements.

### Module 20: Viral Referral & Gamification System
- Unique alphanumeric referral codes and personalized shareable deep links (WhatsApp, Telegram, SMS).
- Multi-tier reward rule: ₹250 bonus to referrer when referee completes their first sell order; ₹150 discount to referee.
- Leaderboards and milestone rewards (e.g., "Refer 5 friends and win an Apple AirPods Pro").

### Module 21: Omnichannel Notification Hub
- Notifications categorized into `Orders`, `Promotions`, and `Account Alerts`.
- Multi-channel delivery engine:
  - Native Push Notifications (Firebase Cloud Messaging with rich media).
  - WhatsApp Business API for order tracking, pickup alerts, and invoices.
  - Transactional SMS (Twilio / Gupshup) for OTPs and payout credits.
  - Transactional Emails (SendGrid / AWS SES) with attached PDF invoices.

### Module 22: Order Management & Tracking
- Unified timeline view of all customer activities:
  - Sell Orders (Scheduled -> Agent Assigned -> Out for Pickup -> Verified -> Paid).
  - Buy Orders (Processing -> Packed -> Shipped -> Out for Delivery -> Delivered).
  - Repair Bookings (Confirmed -> Technician En Route -> Repair In-Progress -> Completed).
- One-tap invoice PDF download and cancellation/return requests within 7-day window.

### Module 23: User Profile & Security Center
- Personal profile details: Name, Email, Phone number, Profile avatar.
- Saved Addresses with labels (Home, Work, Other) and GPS pin coordinates.
- Saved Payment Accounts: Bank Account details (Account Number, IFSC) and UPI IDs for receiving sell payouts.
- Device security settings: Biometric app lock, Active session management (log out from other devices).

### Module 24: AI Customer Support & Chatbot
- 24/7 conversational support agent built on Gemini 2.5 Flash.
- Resolves queries regarding: Order status, pickup delays, payment disputes, warranty claims, repair technician arrival.
- Intelligent handoff to human support executive with chat history context.

### Module 25: Offline-First Data & Cache Architecture
- Complete offline catalog caching using Hive local database.
- Persistent user draft states (incomplete sell questionnaires, cart items, selected addresses).
- Automatic sync upon network restoration with optimistic UI updates.

---

## 5. End-to-End User Journeys

```
                    ┌───────────────────────────────────────────────┐
                    │               Customer Enters                 │
                    │               App (Home Screen)               │
                    └───────────────────────┬───────────────────────┘
                                            │
        ┌───────────────────┬───────────────┴───────────────┬───────────────────┐
        ▼                   ▼                               ▼                   ▼
┌───────────────┐   ┌───────────────┐               ┌───────────────┐   ┌───────────────┐
│   SELL FLOW   │   │   BUY FLOW    │               │  REPAIR FLOW  │   │ EXCHANGE FLOW │
└───────┬───────┘   └───────┬───────┘               └───────┬───────┘   └───────┬───────┘
        │                   │                               │                   │
  Select Category     Browse Catalog                  Select Device       Select New Phone
  & Brand & Model     & Grade Filter                  & Issue Type        to Purchase
        │                   │                               │                   │
  Enter IMEI &        Inspect 32-Pt                   Instant Cost &      Assess Old Phone
  Age Verification    QC & Specs                      Book Slot           Condition
        │                   │                               │                   │
  Answer Condition    Add to Cart &                   Doorstep Tech       Instant Trade-In
  Questionnaire       Apply Coupon                    Dispatched & GPS    Value Applied
        │                   │                               │                   │
  Run Automated       Select Address                  Before/After Test   Single Delivery
  16 Hardware Tests   & Razorpay/EMI                  & 6-Mo Warranty     & Old Phone QC
        │                   │                               │                   │
  AI Instant Quote    Order Confirmed                 Invoice & Payout    New Phone Handed
  & Lock Price        & Live Courier                  via App             Over to Customer
        │                   │                               │                   │
  Doorstep Pickup &   Delivered with                  Service             Complete
  Instant UPI Pay     Warranty Card                   Completed
```

---

## 6. Complete Screen Sitemap (69 Flutter Screens)

### Group 1: Authentication & Onboarding (5 Screens)
1. `SplashScreen` — Dynamic brand animation, initialization check, auth token verification.
2. `OnboardingScreen` — Value proposition walkthrough sliders.
3. `LoginScreen` — Phone number / Email input with Social login triggers.
4. `OtpVerificationScreen` — 6-digit auto-fill OTP with countdown timer and resend.
5. `ForgotPasswordScreen` — Password recovery link request.

### Group 2: Home & Core Navigation (6 Screens)
6. `MainShellScreen` — Persistent bottom navigation bar container (Home, Sell, Buy, Repair, Profile).
7. `HomeScreen` — Hero banners, category grid, quick actions, trending buyback, refurbished deals.
8. `SearchScreen` — Full-text predictive search with recent history and popular terms.
9. `CitySelectionScreen` — City and pincode selector modal with GPS detection.
10. `NotificationCenterScreen` — Grouped alerts (Orders, Offers, Account).
11. `CouponsScreen` — Available coupons, terms, and copy-code interactions.

### Group 3: Sell Device Flow (15 Screens)
12. `SellCategorySelectScreen` — Category picker (Phones, Laptops, Tablets, etc.).
13. `SellBrandSelectScreen` — Grid of brand logos with search filter.
14. `SellModelSelectScreen` — Model series list with thumbnail images.
15. `SellVariantSelectScreen` — RAM, Storage, and Color selection chips.
16. `SellImeiInputScreen` — Manual 15-digit input and camera barcode scanner.
17. `SellDeviceAgeScreen` — Bill availability, purchase year, and warranty duration.
18. `SellScreenConditionScreen` — Visual condition selector for front glass and display.
19. `SellBodyConditionScreen` — Body scratch and dent grading.
20. `SellFunctionalIssuesScreen` — Multi-select checklist of hardware faults.
21. `SellDiagnosticsIntroScreen` — Hardware permissions and test instructions.
22. `SellDiagnosticsProgressScreen` — Live automated test runner.
23. `SellQuoteCalculationScreen` — Animated AI valuation calculation loader.
24. `SellQuoteResultScreen` — Instant price display, price breakdown, price lock button.
25. `SellPickupAddressScreen` — Address selection or GPS pin drop.
26. `SellPaymentMethodScreen` — Bank account (IMPS) or UPI ID selection for payout.

### Group 4: Automated Hardware Diagnostics Suite (12 Screens)
27. `TouchScreenTestScreen` — Interactive full-screen touch grid test.
28. `DisplayColorTestScreen` — Full-screen primary color cycling for dead pixel detection.
29. `CameraFrontTestScreen` — Front camera selfie capture and face detection.
30. `CameraRearTestScreen` — Rear camera autofocus and flash verification.
31. `MicrophoneTestScreen` — Real-time waveform audio recording test.
32. `SpeakerTestScreen` — Audio frequency playback and user number input verification.
33. `EarpieceTestScreen` — Proximity earpiece audio check.
34. `VibrationTestScreen` — Pattern vibration confirmation prompt.
35. `ProximitySensorTestScreen` — Hand proximity gesture detector.
36. `SensorsTestScreen` — Gyroscope & Accelerometer 3D cube tilt test.
37. `ConnectivityTestScreen` — Wi-Fi, Bluetooth, GPS auto-ping verification.
38. `DiagnosticsSummaryScreen` — Final report card of passed/failed tests.

### Group 5: Buy Refurbished Marketplace (10 Screens)
39. `BuyCatalogScreen` — Infinite scrolling grid of products with grade badges.
40. `FilterBottomSheetScreen` — Multi-facet filter (Brand, Price, RAM, Storage, Grade).
41. `ProductDetailScreen` — Image carousel, 32-point inspection certificate, specs, warranty.
42. `ProductSpecsScreen` — Comprehensive technical specs sheet.
43. `ProductCompareScreen` — Side-by-side spec and price comparison table.
44. `WishlistScreen` — Saved products with price-drop badges.
45. `CartScreen` — Cart items list, warranty add-ons, coupon field, price summary.
46. `CheckoutAddressScreen` — Delivery address selector and delivery speed option.
47. `PaymentScreen` — Razorpay SDK launcher, UPI apps, Cards, NetBanking, COD.
48. `OrderSuccessScreen` — Lottie animation, order ID, delivery estimate, invoice trigger.

### Group 6: Doorstep Repair Module (8 Screens)
49. `RepairCategoryScreen` — Device selector for repair (Phone, Laptop, Tablet).
50. `RepairModelSelectScreen` — Model picker with repair pricing index.
51. `RepairIssueSelectScreen` — Screen, Battery, Port, Mic, Camera with upfront costs.
52. `RepairQuoteScreen` — Total repair estimate with parts warranty terms.
53. `RepairSlotBookingScreen` — Date & time slot picker with doorstep address.
54. `RepairOrderSuccessScreen` — Booking confirmed with technician assignment alert.
55. `TechnicianTrackingScreen` — Live Google Maps tracking of technician arrival.
56. `RepairChecklistScreen` — Digital sign-off report before and after repair.

### Group 7: Wallet, Referrals & Rewards (5 Screens)
57. `WalletHomeScreen` — Total balance, breakdown (Cashback, Refund, Referral), Add/Withdraw.
58. `WalletTransactionsScreen` — Filterable history of credits and debits.
59. `ReferralDashboardScreen` — Referral code, share buttons, earnings statistics.
60. `ReferralLeaderboardScreen` — Monthly top referrers and reward tiers.
61. `RewardsScratchCardScreen` — Interactive gamified scratch cards for cashback.

### Group 8: Profile, Orders & Settings (8 Screens)
62. `ProfileHomeScreen` — Account overview, quick links to orders, addresses, settings.
63. `OrderHistoryScreen` — Tabs for Sell Orders, Buy Orders, Repair Orders.
64. `OrderDetailScreen` — Live timeline, tracking links, agent details, cancel/return.
65. `SavedAddressesScreen` — Manage addresses with edit, delete, set default.
66. `SavedPaymentMethodsScreen` — Saved UPI IDs and bank accounts for instant payouts.
67. `CustomerSupportChatScreen` — AI Chatbot assistant with human handover button.
68. `SettingsScreen` — Dark mode toggle, biometric app lock, language, notifications toggle.
69. `TermsPrivacyScreen` — Legal terms of service, privacy policy, and circular e-waste compliance.

---

## 7. Non-Functional Requirements (NFRs)

| Metric | Target SLA | Strategy / Architecture |
| :--- | :--- | :--- |
| **Cold App Launch** | < 1.8 seconds | Deferred library imports, Flutter AOT compilation, native splash screen. |
| **Warm App Launch** | < 500 ms | Cached state in memory via Riverpod container. |
| **API Latency (p95)**| < 350 ms | Redis caching layer for catalog & pricing models; connection pooling with async SQLAlchemy. |
| **Crash-Free Rate** | > 99.8% | Rigorous exception handling, Sentry / Firebase Crashlytics integration. |
| **Offline Capability**| Read-only offline catalog | Local Hive storage caching product list, past orders, and user addresses. |
| **Security Standards**| Banking-grade | TLS 1.3 enforced, SSL certificate pinning, AES-256 encrypted Hive boxes. |
| **Scalability** | 100,000 Concurrent Users | Horizontal auto-scaling FastAPI containers behind Cloudflare and AWS ALB. |

---

## 8. Third-Party Integrations & Services

```
┌────────────────────────────────────────────────────────────────────────┐
│                        CASHIFY CLONE CORE PLATFORM                     │
├─────────────────┬─────────────────┬──────────────────┬─────────────────┤
│  Authentication │    Payments     │    Logistics     │  Communication  │
├─────────────────┼─────────────────┼──────────────────┼─────────────────┤
│ • Firebase Auth │ • Razorpay      │ • Google Maps API│ • Firebase FCM  │
│   (Phone OTP)   │   (Cards, UPI,  │   (Geocoding &   │ • WhatsApp      │
│ • Google Sign-In│    NetBanking)  │    Directions)   │   Business API  │
│ • Apple ID      │ • Cashfree Payout│ • Shiprocket API│ • Twilio SMS    │
│   (OAuth 2.0)   │   (Instant IMPS)│   (Buy Delivery) │ • SendGrid Email│
└─────────────────┴─────────────────┴──────────────────┴─────────────────┘
```

---

## 9. Regulatory & Legal Compliance
1. **Circular Economy & E-Waste Regulations:** Full compliance with Central Pollution Control Board (CPCB) Extended Producer Responsibility (EPR) guidelines in India.
2. **Data Protection & Privacy:** Adherence to India's Digital Personal Data Protection Act (DPDP Act 2023) — explicit user consent for diagnostic hardware permissions and secure data wiping guarantee for sold devices.
3. **Consumer Protection:** Clear display of refurbished grade criteria, 7-day replacement policies, and transparent repair warranty terms.
