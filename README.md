# Finance Tracker - Flutter Web Application

A comprehensive finance management application built with Flutter for web, designed to help manage client finances, schemes, and transactions.

## 🚀 Features

### Core Functionality
- **User Management**: Add, edit, and manage client information with automated Indian address system
- **Daily Entry**: Record daily transactions with searchable user interface
- **Scheme Management**: Manage Gold, Furniture, and Savings schemes
- **Analytics & Reports**: Comprehensive reporting with charts and filters
- **Bonus Management**: Track and manage client bonuses
- **Payment Handling**: Process various payment modes

### Key Features
- 📱 **Responsive Design**: Works seamlessly on desktop and mobile browsers
- 🎨 **Modern UI**: Clean, intuitive interface with Material Design
- 📊 **Analytics**: Interactive charts and detailed reporting
- 🔍 **Search Functionality**: Quick user search in daily entry
- 🏠 **Address Automation**: Automated Indian states, districts, cities, and areas
- 💰 **Bonus System**: Automated bonus calculation (5% for every 100₹)
- 📈 **Real-time Analytics**: Live dashboard with key metrics

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Charts**: fl_chart
- **Storage**: SharedPreferences
- **Platform**: Web (Chrome, Firefox, Safari, Edge)

## 📦 Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Web browser (Chrome recommended)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/sudhikumaran-fortumars/Finance-Tracker.git
   cd Finance-Tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run -d chrome
   ```

4. **Build for production**
   ```bash
   flutter build web --release
   ```

## 🌐 Deployment Options

### Option 1: Netlify (Recommended)
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop the `build/web` folder
3. Get instant URL like `https://your-app-name.netlify.app`

### Option 2: Vercel
1. Go to [vercel.com](https://vercel.com)
2. Import your project or drag `build/web` folder
3. Get instant URL like `https://your-app-name.vercel.app`

### Option 3: GitHub Pages
1. Enable GitHub Pages in repository settings
2. Upload the `build/web` contents
3. Get URL like `https://username.github.io/Finance-Tracker`

### Option 4: Firebase Hosting
```bash
firebase init hosting
firebase deploy
```

## 📱 Application Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── transaction.dart
│   ├── scheme_type.dart
│   └── ...
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── user_management_screen.dart
│   ├── daily_entry_screen.dart
│   ├── reports_screen.dart
│   └── ...
├── providers/                # State management
│   ├── data_provider.dart
│   ├── navigation_provider.dart
│   └── theme_provider.dart
├── services/                 # Business logic
│   ├── storage_service.dart
│   └── indian_address_service.dart
├── widgets/                  # Reusable widgets
│   ├── charts/
│   └── common/
└── utils/                    # Utilities
    ├── analytics.dart
    └── calculations.dart
```

## 🎯 Key Features Explained

### User Management
- Automated Indian address system with states, districts, cities
- Client serial number generation
- Scheme assignment during user creation
- Comprehensive client information storage

### Daily Entry System
- Searchable user interface
- Transaction recording with payment modes
- Automatic bonus calculation (5% for every 100₹)
- Real-time scheme information display

### Analytics & Reporting
- Interactive charts (Bar, Doughnut, Line)
- Client-wise and period-wise analytics
- Date range filtering
- Export functionality
- Daily transaction summaries

### Bonus Management
- Automatic bonus calculation based on transaction amounts
- Manual bonus addition capability
- Client bonus tracking and history
- Bonus transaction records

## 🔧 Configuration

### Scheme Types
The application supports three main scheme types:
- **Gold**: Gold investment schemes
- **Furniture**: Furniture purchase schemes  
- **Savings**: General savings schemes

### Bonus Logic
- 5₹ bonus for every 100₹ transaction
- Automatic calculation based on transaction date
- 7-day rule for bonus eligibility

## 📊 Data Models

### User Model
- Personal information (name, mobile, address)
- Serial number and client ID
- Assigned scheme information
- Status tracking

### Transaction Model
- Amount and payment mode
- Date and time
- User association
- Bonus calculations

### Scheme Model
- Scheme type and amount
- Interest rate and duration
- Collection frequency
- Status management

## 🚀 Performance Optimizations

- Tree-shaking for reduced bundle size
- Lazy loading of screens
- Efficient state management
- Optimized chart rendering
- Responsive design patterns

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions, please open an issue in the GitHub repository.

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- fl_chart for beautiful chart components
- Material Design for UI guidelines
- Indian address data for location services

---

**Built with ❤️ using Flutter**