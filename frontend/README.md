# DailyDine - Smart Restaurant Reservation & Order Management System

DailyDine is a comprehensive Flutter application that enables customers to book tables, place orders, and check in seamlessly. Built with modern Flutter architecture and best practices.

## 🚀 Features

### Customer-Side (Online)
- ✅ **Online Table Booking** – Real-time table reservations via app or web
- ✅ **Digital Menu & Ordering** – View menu and place orders before or after arriving
- ✅ **QR Code-Based Check-In** – Check in by scanning booking QR codes

### Restaurant-Side (Connected)
- ✅ **Real-Time Dashboard** – Live reservations and orders for staff
- ✅ **Smart Table Allocation** – Automatic table assignment based on availability
- ✅ **Kitchen View / Order Printing** – Direct order routing to kitchen display
- ✅ **Customer Verification** – Staff QR scanning for customer verification

## 🏗️ Project Architecture

### Technology Stack
- **Frontend**: Flutter 3.7.2+
- **State Management**: BLoC/Cubit pattern
- **Navigation**: GoRouter
- **Network**: Dio + Retrofit
- **Local Storage**: SharedPreferences + Hive
- **UI**: Material Design 3 with custom theme

### Project Structure
```
lib/
├── core/                          # Core application layer
│   ├── constants/                 # App constants and configuration
│   ├── theme/                     # App theme and styling
│   ├── utils/                     # Utility functions
│   ├── network/                   # API service and network layer
│   ├── storage/                   # Local storage services
│   └── routes/                    # App routing configuration
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication feature
│   ├── profile/                   # User profile management
│   ├── wallet/                    # Digital wallet functionality
│   ├── favorites/                 # Favorites management
│   └── home/                      # Home screen and navigation
├── shared/                        # Shared components
│   ├── widgets/                   # Reusable UI widgets
│   ├── models/                    # Data models
│   └── services/                  # Shared services
└── main.dart                      # App entry point
```

## 📱 Implemented Features

### 1. Profile Management
- **Profile Page**: Display user information, stats, and quick actions
- **Edit Profile**: Comprehensive form for updating user details
- **Avatar Management**: Upload and manage profile pictures
- **Verification Status**: Email and phone verification indicators

### 2. Digital Wallet
- **Balance Display**: Real-time wallet balance with currency support
- **Transaction History**: Complete transaction log with status tracking
- **Recharge Options**: Multiple payment methods for wallet top-up
- **Withdrawal**: Bank transfer functionality

### 3. Favorites System
- **Restaurant Favorites**: Save and manage favorite restaurants
- **Menu Item Favorites**: Save favorite dishes and menu items
- **Tabbed Interface**: Separate tabs for restaurants and menu items
- **Quick Actions**: Add/remove favorites with confirmation dialogs

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dailydine
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files** (for JSON serialization and API client)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Environment Configuration

1. **Update API Base URL**
   - Open `lib/core/constants/app_constants.dart`
   - Update `baseUrl` with your backend API endpoint

2. **Configure Assets**
   - Add required images to `assets/images/`
   - Add icons to `assets/icons/`
   - Add fonts to `assets/fonts/`

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `retrofit`: API client generation
- `shared_preferences`: Local storage
- `hive`: NoSQL database
- `json_annotation`: JSON serialization

### UI Dependencies
- `google_fonts`: Typography
- `flutter_svg`: SVG support
- `cached_network_image`: Image caching
- `shimmer`: Loading animations

### Development Dependencies
- `build_runner`: Code generation
- `json_serializable`: JSON serialization
- `retrofit_generator`: API client generation
- `hive_generator`: Hive adapters

## 🎨 Design System

### Color Palette
- **Primary**: `#1E88E5` (Blue)
- **Secondary**: `#FF6B35` (Orange)
- **Accent**: `#4CAF50` (Green)
- **Error**: `#E53935` (Red)
- **Warning**: `#FF9800` (Orange)

### Typography
- **Font Family**: Poppins
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

## 🔧 Development Guidelines

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### State Management
- Use BLoC for complex state management
- Use Cubit for simple state management
- Keep business logic in BLoC/Cubit
- Use Equatable for state comparison

### File Organization
- Feature-based architecture
- Separate UI, business logic, and data layers
- Use consistent naming conventions
- Group related files together

## 🚀 Next Steps

### Planned Features
- [ ] Authentication system
- [ ] Restaurant discovery
- [ ] Table booking flow
- [ ] Menu browsing
- [ ] Order placement
- [ ] QR code generation
- [ ] Push notifications
- [ ] Offline support

### Backend Integration
- [ ] API endpoint configuration
- [ ] Authentication tokens
- [ ] Real-time updates
- [ ] Error handling
- [ ] Data synchronization

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support and questions, please contact the development team or create an issue in the repository.
