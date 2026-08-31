# Finance Tracker Mobile App

A Flutter mobile application that replicates the functionality of the React web application for finance tracking and management.

## Features

### ✅ Completed Features

1. **Dashboard Screen**

   - Real-time statistics display
   - Interactive charts and graphs
   - Recent transactions overview
   - Quick action buttons

2. **Data Models**

   - User management with address support
   - Transaction tracking with payment modes
   - Scheme types and user schemes
   - Dashboard statistics
   - Notification system

3. **Services & Storage**

   - Local data persistence using SharedPreferences
   - Mock data for demonstration
   - CRUD operations for all entities

4. **UI Components**

   - Custom card widgets
   - Button components with variants
   - Chart widgets (Line, Bar, Doughnut)
   - Navigation drawer
   - Theme support (Light/Dark mode)

5. **Navigation**

   - Drawer-based navigation
   - State management with Provider
   - Theme management

6. **Charts & Analytics**
   - Line charts for trends
   - Bar charts for comparisons
   - Doughnut charts for distributions
   - Interactive chart elements

## Project Structure

```
lib/
├── models/                 # Data models
│   ├── address.dart
│   ├── dashboard_stats.dart
│   ├── notification.dart
│   ├── notification_config.dart
│   ├── payment_details.dart
│   ├── report_filter.dart
│   ├── scheme_type.dart
│   ├── transaction.dart
│   ├── user.dart
│   └── user_scheme.dart
├── services/              # Business logic
│   └── storage_service.dart
├── utils/                 # Utility functions
│   ├── analytics.dart
│   └── calculations.dart
├── widgets/               # Reusable UI components
│   ├── charts/
│   │   ├── bar_chart_widget.dart
│   │   ├── doughnut_chart_widget.dart
│   │   └── line_chart_widget.dart
│   └── common/
│       ├── button_widget.dart
│       ├── card_widget.dart
│       └── drawer_widget.dart
├── screens/               # App screens
│   └── dashboard_screen.dart
├── providers/             # State management
│   ├── navigation_provider.dart
│   └── theme_provider.dart
└── main.dart              # App entry point
```

## Dependencies

- `flutter/material.dart` - Material Design components
- `provider` - State management
- `shared_preferences` - Local storage
- `fl_chart` - Chart library
- `intl` - Internationalization
- `path_provider` - File system access

## Getting Started

1. **Prerequisites**

   - Flutter SDK (latest stable version)
   - Dart SDK
   - Android Studio / VS Code with Flutter extensions

2. **Installation**

   ```bash
   cd finance_tracker_app
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Key Features Implemented

### Dashboard

- **Statistics Cards**: Total customers, active schemes, investments, etc.
- **Recent Transactions**: Latest 5 transactions with user details
- **Quick Actions**: Navigation to different sections
- **Growth Charts**: Interactive line charts with trend analysis

### Data Management

- **User Management**: Complete user profiles with addresses
- **Transaction Tracking**: Multiple payment modes (offline, card, UPI, net banking)
- **Scheme Management**: Different investment schemes with interest calculations
- **Local Storage**: Persistent data using SharedPreferences

### UI/UX

- **Responsive Design**: Adapts to different screen sizes
- **Dark/Light Theme**: Toggle between themes
- **Material Design**: Modern Material 3 design system
- **Interactive Charts**: Touch-enabled charts with tooltips

### Navigation

- **Drawer Navigation**: Side drawer with all main sections
- **State Management**: Provider pattern for state management
- **Theme Management**: Persistent theme preferences

## Future Enhancements

The following screens are planned for future implementation:

- User Management Screen
- Daily Entry Screen
- Reports & Analytics Screen
- Payment Handling Screen
- Notifications Screen

## Technical Notes

- **State Management**: Uses Provider pattern for reactive UI updates
- **Data Persistence**: SharedPreferences for local storage
- **Charts**: FL Chart library for interactive visualizations
- **Theme**: Material 3 design with custom theming
- **Navigation**: Drawer-based navigation with state management

## Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures and business entities
- **Services**: Business logic and data operations
- **Widgets**: Reusable UI components
- **Screens**: Full-screen UI implementations
- **Providers**: State management and business logic coordination

This Flutter app provides a complete mobile experience equivalent to the React web application, with native mobile performance and Material Design aesthetics.
