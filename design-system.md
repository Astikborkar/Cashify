# Flutter Design System — Cashify Clone
## Complete UI/UX Specification & Component Library

---

### Design System Version
- **Version:** 1.0.0 (Material 3 Compliant)
- **Target Framework:** Flutter 3.35+
- **Grid System:** Strict 8px Baseline Grid
- **Design Philosophy:** Clean, Trust-Building, High Contrast, Micro-Interaction Rich

---

## 1. Color Palette & Token Architecture

The color system is optimized for trust, high conversion rates, and clear status communication. All colors are defined in light and dark mode variants.

### 1.1 Brand & Semantic Color Tokens

| Token Name | Hex Code | Purpose / Usage |
| :--- | :--- | :--- |
| `primary` | `#00C853` | Primary brand green, primary action buttons, instant quote highlights, success states. |
| `primaryDark` | `#009624` | Pressed state for primary button, dark mode primary accents. |
| `primaryLight` | `#E8F8EE` | Light tint for badges, selected chip backgrounds, card accents. |
| `secondary` | `#2962FF` | Trust blue for Buy Refurbished tags, diagnostic passes, info banners. |
| `secondaryDark` | `#0039CB` | Active state for secondary buttons and blue badges. |
| `secondaryLight` | `#EBF2FF` | Background for info banners and category highlights. |
| `accent` | `#FFB300` | Warning amber, star ratings, promotional discount tags, fast selling badges. |
| `accentLight` | `#FFF8E1` | Background for discount chips and coupon card borders. |
| `error` | `#E53935` | Hardware test failure, validation errors, price deductions, cancellation. |
| `errorLight` | `#FFEBEE` | Background for failed diagnostic cards and error banners. |
| `success` | `#43A047` | Order confirmed, payment successful, diagnostic test passed. |
| `surfaceLight` | `#FFFFFF` | Card surfaces, modal sheets, input backgrounds in light theme. |
| `surfaceDark` | `#1E1E1E` | Card surfaces and dialog sheets in dark theme. |
| `backgroundLight` | `#F7F8FA` | App scaffold background in light theme. |
| `backgroundDark` | `#121212` | App scaffold background in dark theme. |
| `borderLight` | `#E0E0E0` | Subtle outline for cards, dividers, and unselected chips. |
| `borderDark` | `#2C2C2C` | Dark mode dividers and outlines. |

### 1.2 Neutral Monochrome Scale

| Token Name | Hex Code | Description |
| :--- | :--- | :--- |
| `neutral900` | `#1A1D20` | Highest contrast text (Headlines, body in light mode). |
| `neutral700` | `#4A5568` | Secondary labels, descriptions, unselected icon tints. |
| `neutral500` | `#718096` | Placeholder text, disabled labels, timestamps. |
| `neutral300` | `#CBD5E1` | Disabled button borders, subtle grid lines. |
| `neutral100` | `#F1F5F9` | Shimmer loader base color, inactive segment backgrounds. |
| `neutral50` | `#F8FAFC` | Light input field fill background. |

---

## 2. Typography Scale (8-Level Hierarchy)

The typography scale uses **Inter** (fallback: **SF Pro** on iOS, **Roboto** on Android) to provide optimal legibility for monetary values, technical specifications, and condition questionnaires.

```
┌────────────────────────────────────────────────────────────────────────┐
│                      TYPOGRAPHY SCALE HIERARCHY                        │
├─────────────────┬───────┬─────────┬──────────────┬─────────────────────┤
│ Style Name      │ Size  │ Weight  │ Line Height  │ Example Usage       │
├─────────────────┼───────┼─────────┼──────────────┼─────────────────────┤
│ H1 / Display    │ 34 sp │ Bold    │ 40 sp (1.18) │ Instant Price Quote │
│ H2 / Headline   │ 28 sp │ SemiBold│ 34 sp (1.21) │ Screen Headers      │
│ H3 / Subheading │ 22 sp │ SemiBold│ 28 sp (1.27) │ Section Headings    │
│ Title Large     │ 18 sp │ Medium  │ 24 sp (1.33) │ Card Titles, Appbar │
│ Title Medium    │ 16 sp │ SemiBold│ 22 sp (1.38) │ Product Name, Price │
│ Body Regular    │ 16 sp │ Regular │ 24 sp (1.50) │ Descriptive Body    │
│ Body Small      │ 14 sp │ Regular │ 20 sp (1.43) │ Specs, Form Helper  │
│ Caption / Label │ 12 sp │ Medium  │ 16 sp (1.33) │ Badges, Timestamps  │
└─────────────────┴───────┴─────────┴──────────────┴─────────────────────┘
```

### Flutter TextTheme Implementation Example
```dart
TextTheme appTextTheme(ColorScheme colorScheme) {
  return TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: colorScheme.onSurface,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: colorScheme.onSurface,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: colorScheme.onSurfaceVariant,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: colorScheme.onSurfaceVariant,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: colorScheme.onSurfaceVariant,
    ),
  );
}
```

---

## 3. Spacing, Elevation & Corner Radius System

A strict **8px baseline grid** governs all padding, margins, gaps, and component sizing.

### 3.1 Spacing Tokens
- `xs` = `4.0` (Micro gaps, icon-to-text spacing)
- `sm` = `8.0` (Inner card padding, chip gaps)
- `md` = `16.0` (Standard screen horizontal padding, card content padding)
- `lg` = `24.0` (Section gaps, vertical spacing between groups)
- `xl` = `32.0` (Major section dividers, empty state padding)
- `2xl` = `48.0` (Hero banner margins, onboarding bottom spacing)

### 3.2 Corner Radius Tokens
- `radiusSm` = `8.0` (Small chips, secondary buttons, tags)
- `radiusMd` = `12.0` (Text inputs, standard product cards, bottom sheets)
- `radiusLg` = `16.0` (Hero cards, quote cards, diagnostic test containers)
- `radiusPill` = `999.0` (Pill badges, rounded action buttons)

### 3.3 Elevation & Shadows (Light Mode)
- **Elevation 0:** Border only (`#E0E0E0`, 1px width).
- **Elevation 1 (Card Rest):** `BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))`
- **Elevation 2 (Card Hover/Pressed):** `BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4))`
- **Elevation 3 (Sticky CTA Bar / Bottom Sheet):** `BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, -4))`

---

## 4. Reusable UI Components

### 4.1 Buttons
All primary buttons have a fixed height of **52px** on mobile for optimal thumb reachability.

1. **Filled Primary Button:**
   - Background: `primary` (`#00C853`), Text: White, Corner Radius: `12px`.
   - Used for: "Get Exact Value", "Add to Cart", "Book Repair", "Confirm Pickup".
2. **Outline Secondary Button:**
   - Border: 1.5px `primary`, Background: Transparent, Text: `primary`.
   - Used for: "View Details", "Compare Specs", "Apply Coupon".
3. **Ghost / Text Button:**
   - Background: Transparent, Text: `secondary` (`#2962FF`).
   - Used for: "Skip Diagnostics", "Change Address", "View All".
4. **Loading Button:**
   - Replaces text with a centered `24px` white `CircularProgressIndicator` while keeping width fixed to prevent layout shift.
5. **Icon Button:**
   - 44x44px touch target, circle or rounded-rect background with subtle hover splash.

### 4.2 Reusable Cards

#### A. Product Card (Refurbished Marketplace)
- Width: `170px` (in horizontal carousels) or flexible grid cell.
- Top Badge: `Superb Grade` (Green chip) or `35% OFF` (Amber chip).
- Image: High-res cutout image on neutral light gray background with `CachedNetworkImage`.
- Title: 2-line truncated device name (e.g., "Apple iPhone 13 (Midnight, 128 GB)").
- Price Row: Current refurbished price (Bold 16sp) + Strikethrough MRP + Discount %.
- Assurance Tag: "✓ 6 Months Warranty".

#### B. Sell Quote Card
- Gradient Header: Deep Green to Primary Green (`#009624` -> `#00C853`).
- Large Display Value: "₹ 34,500" with "Instant Cash Guaranteed" subtitle.
- Deduction Summary Row: Expandable list showing exact deductions based on condition answers.
- 7-Day Price Lock countdown badge with lock icon.

#### C. Hardware Diagnostic Test Card
- Square or rounded-rect container with 80px minimum height.
- Status Indicator:
  - Pending: Grey border with subtle blue pulse.
  - Running: Spinning radial arc with camera/mic icon.
  - Passed: Bold Green background with checkmark icon (`✓ Passed`).
  - Failed: Light red background with warning icon (`⚠ Failed`).

#### D. Repair Booking Card
- Left Icon: Colored icon representing repair category (Screen, Battery, Speaker).
- Title & Turnaround: "Screen Replacement (30 Mins Doorstep)".
- Pricing: Upfront transparent cost with "Free Doorstep Inspection".

#### E. Wallet & Transaction Card
- Transaction Type Icon: Green downward arrow (Credit/Cashback) or Red upward arrow (Withdrawal).
- Description: "Cashback for Order #CSH-9812".
- Amount: `+ ₹500` in Bold Green with timestamp.

### 4.3 Form Components
1. **AppTextField:**
   - Filled style with `#F8FAFC` background in light mode, `#242424` in dark mode.
   - 12px rounded corner radius with subtle border transition to `primary` on focus.
   - Clear icon button (`X`) when text is entered.
2. **OTP Input Field:**
   - 6 individual rounded square boxes (50x56px each).
   - Auto-advance on input, auto-paste from clipboard, vibrate on wrong entry.
3. **Selection Radio & Checkbox Cards:**
   - Full-width selectable card used in condition questionnaires.
   - Unselected: White background, 1px `#E0E0E0` border.
   - Selected: `#E8F8EE` background, 2px `#00C853` border, green checkmark icon on right.
4. **Time Slot Selector:**
   - Horizontal pill list showing Date (e.g., "Today, 24 Sep") followed by time chips (e.g., "09:00 AM - 12:00 PM").

---

## 5. Navigation & Scaffold Architecture

### 5.1 Bottom Navigation Bar
Persistent Material 3 Navigation Bar with 5 destinations:
1. **Home:** `Icons.home_rounded` -> Primary dashboard, banners, search.
2. **Sell:** `Icons.phone_android_rounded` (with subtle green highlight pill) -> Instant valuation flow.
3. **Buy:** `Icons.shopping_bag_outlined` -> Refurbished catalog & deals.
4. **Repair:** `Icons.build_outlined` -> Doorstep repair booking.
5. **Profile:** `Icons.person_outline_rounded` -> Orders, wallet, settings.

### 5.2 Top AppBars
- **Standard Screen AppBar:** Back button (arrow_back_ios_new, 20sp), Title centered/left, and Action icon (Cart with badge or Share).
- **Search Header AppBar:** Embedded search text field with voice search and clear buttons.

### 5.3 Sticky Bottom Action Bar (CTA)
- Elevated bottom bar anchored above system navigation pill.
- Left column: Price summary or selected items count.
- Right column: Full-width or half-width Primary Button.

---

## 6. Motion & Micro-Interactions

| Interaction | Duration | Curve | Behavior |
| :--- | :--- | :--- | :--- |
| **Page Transition** | 300 ms | `Curves.easeInOutCubic` | Horizontal slide & fade (iOS standard). |
| **Button Tap Feedback**| 120 ms | `Curves.easeOut` | Subtle scale down to 0.97 + Light Haptic vibration. |
| **Diagnostic Test Pass**| 400 ms | `Curves.elasticOut` | Checkmark scale-in with Green fill burst + Success Haptic. |
| **Price Counter** | 800 ms | `Curves.decelerate` | Animated rolling number from ₹0 to evaluated quote. |
| **Shimmer Loader** | 1200 ms | `Curves.linear` (Repeat)| Gradient sweep across placeholder boxes. |

---

## 7. Accessibility & Inclusivity (a11y)
- **Color Contrast:** All text tokens meet WCAG 2.1 AA standards (minimum contrast ratio of 4.5:1 against respective backgrounds).
- **Minimum Touch Target:** All interactive controls maintain a minimum of **48x48 dp** hit area.
- **Screen Reader Support:** Meaningful `Semantics` labels on all product cards, diagnostic test states, and price breakdown rows.
- **Text Scaling:** Supports dynamic system text scaling up to 1.3x without layout overflow via `FittedBox` and `SingleChildScrollView`.
