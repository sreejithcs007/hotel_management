# Hotel Room Booking App (Flutter Web)

A single-page Flutter Web application built with **GetX** for state management and **GoRouter** for URL navigation and routing.

---

## 🚀 Quick Start

Ensure you have Flutter installed and web enabled:

```bash
# Enable web support (if not already enabled)
flutter config --enable-web

# Get dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome
```

To run the automated test suite:

```bash
flutter test
```

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter (Web target)
- **State Management & DI**: `GetX` (`GetxController`, `Rx`, `Obx`, `Get.put`)
- **Navigation & Routing**: `GoRouter` (`MaterialApp.router` with `/` route and custom 404 fallback page)
- **Formatting**: `intl` (Indian Rupee `₹` currency formatting, Date formatting)
- **Folder Structure**: Clean feature-based structure (`lib/modules/unauthorised/room_booking`, `lib/routes`, `lib/shared`, `lib/core`).

---

## ✨ Features Implemented

### 1. Core Requirements
- **Room Selection**: Hardcoded list of 5 hotel rooms with code, room type, max guest capacity, and price/night:
  - `R101` | Deluxe Room | ₹3,500 / night | Max 2 guests
  - `R102` | Deluxe Room | ₹3,500 / night | Max 2 guests
  - `R201` | Executive Suite | ₹5,800 / night | Max 3 guests
  - `R202` | Executive Suite | ₹5,800 / night | Max 3 guests
  - `R301` | Family Room | ₹4,200 / night | Max 4 guests
- **Stay Date Selection**: Interactive date pickers for Check-in and Check-out.
- **Automatic Calculations**: Computes total stay duration (nights) and total stay cost (`nights × price/night`) reactively via GetX `Obx`.
- **Inline Date & Input Validation**:
  - Requires room selection before summary calculation.
  - Check-in date cannot be in the past (today is allowed).
  - Check-out date must be strictly after check-in date (same-day stays and inverted ranges produce clean inline error cards without crashing).
- **Responsive Layout**: Desktop split-view (rooms on left, dates & summary on right) and stacked mobile layout.

### 2. Bonus Features
- **Double-Booking Overlap Prevention**: Checks requested stay range `[checkIn, checkOut)` against existing hardcoded bookings for that room. Unavailable rooms display a red badge ("Booked for dates") and selection triggers a clear inline error.
- **Guest Capacity Filter**: Filter chips allowing users to filter rooms by capacity (All Rooms, 2+ Guests, 3+ Guests, 4+ Guests).
- **GoRouter 404 Web Fallback**: Custom `NotFoundScreen` handles invalid URL entry on Web.
- **Comprehensive Unit Tests**: Full `flutter test` suite covering night/price calculations, validation rules, overlap checks, guest filtering, and router resolution.

---

## 📋 Assumptions & Scope Notes

1. **Check-in Today**: Check-in is allowed starting today.
2. **Date Range**: Check-out date must be at least 1 day after check-in.
3. **No Persistence**: As per test scope instructions, no backend or database persistence is included.

---

## 🔮 Future Improvements

With more time, the application could be enhanced with:
1. Integration with a backend REST API or Firebase for persistent booking storage.
2. Advanced visual date range picker calendar widget.
3. Authentication flow and payment gateway checkout integration.
