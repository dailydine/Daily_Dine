# DailyDine - Project Architecture & Development Guidelines

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Project Structure](#project-structure)
3. [Architecture Patterns](#architecture-patterns)
4. [State Management](#state-management)
5. [Navigation](#navigation)
6. [Network Layer](#network-layer)
7. [Local Storage](#local-storage)
8. [UI/UX Guidelines](#uiux-guidelines)
9. [Code Organization](#code-organization)
10. [Development Workflow](#development-workflow)
11. [Testing Strategy](#testing-strategy)
12. [Performance Guidelines](#performance-guidelines)
13. [Security Guidelines](#security-guidelines)
14. [Common Patterns](#common-patterns)
15. [Troubleshooting](#troubleshooting)

---

## 🎯 Project Overview

**DailyDine** is a Smart Restaurant Reservation & Order Management System built with Flutter. The app enables customers to book tables, place orders, and check in seamlessly while connecting with restaurant staff through a Django backend.

### Key Features
- **Customer Side**: Online table booking, digital menu & ordering, QR code-based check-in
- **Restaurant Side**: Real-time booking & order dashboard, smart table allocation, kitchen view

### Tech Stack
- **Frontend**: Flutter 3.7.2+
- **Backend**: Django (provided by backend team)
- **State Management**: BLoC/Cubit pattern
- **Navigation**: GoRouter
- **Network**: Dio + Retrofit
- **Local Storage**: SharedPreferences + Hive
- **Code Generation**: build_runner, json_serializable, retrofit_generator, hive_generator

---

## 📁 Project Structure

```
lib/
├── core/                          # Core application layer
│   ├── constants/                 # App-wide constants
│   │   └── app_constants.dart
│   ├── network/                   # Network layer
│   │   ├── api_service.dart
│   │   └── api_service.g.dart
│   ├── routes/                    # Navigation configuration
│   │   └── app_router.dart
│   ├── storage/                   # Local storage services
│   │   └── storage_service.dart
│   └── theme/                     # App theming
│       └── app_theme.dart
├── features/                      # Feature-based modules
│   ├── home/                      # Home feature
│   │   ├── bloc/                  # State management
│   │   │   └── home_bloc.dart
│   │   ├── pages/                 # UI pages
│   │   │   └── home_page.dart
│   │   └── widgets/               # Feature-specific widgets
│   ├── profile/                   # Profile feature
│   │   ├── bloc/
│   │   │   └── profile_bloc.dart
│   │   ├── pages/
│   │   │   ├── profile_page.dart
│   │   │   └── edit_profile_page.dart
│   │   └── widgets/
│   ├── wallet/                    # Wallet feature
│   │   ├── bloc/
│   │   │   └── wallet_bloc.dart
│   │   ├── pages/
│   │   │   └── wallet_page.dart
│   │   └── widgets/
│   ├── favorites/                 # Favorites feature
│   │   ├── bloc/
│   │   │   └── favorites_bloc.dart
│   │   ├── pages/
│   │   │   └── favorites_page.dart
│   │   └── widgets/
│   ├── auth/                      # Authentication feature (future)
│   ├── booking/                   # Booking feature (future)
│   ├── ordering/                  # Ordering feature (future)
│   └── restaurant/                # Restaurant feature (future)
├── shared/                        # Shared components
│   ├── models/                    # Data models
│   │   ├── user_model.dart
│   │   ├── wallet_model.dart
│   │   └── favorites_model.dart
│   ├── widgets/                   # Reusable widgets
│   │   ├── loading_widget.dart
│   │   └── error_widget.dart
│   └── utils/                     # Utility functions
├── main.dart                      # App entry point
└── generated/                     # Generated files (gitignored)
    ├── *.g.dart
    └── *.freezed.dart

assets/
├── images/                        # Image assets
├── icons/                         # Icon assets
└── animations/                    # Animation assets

test/                              # Test files
├── unit/                          # Unit tests
├── widget/                        # Widget tests
└── integration/                   # Integration tests
```

---

## 🏗️ Architecture Patterns

### 1. Feature-Based Architecture
- **Principle**: Each feature is self-contained with its own BLoC, pages, and widgets
- **Benefits**: Scalability, maintainability, team collaboration
- **Structure**: `features/feature_name/bloc/`, `features/feature_name/pages/`, `features/feature_name/widgets/`

### 2. Clean Architecture Layers
```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  (Pages, Widgets, BLoC/Cubit)       │
├─────────────────────────────────────┤
│           Domain Layer              │
│  (Business Logic, Use Cases)        │
├─────────────────────────────────────┤
│           Data Layer                │
│  (Repository, Data Sources)         │
├─────────────────────────────────────┤
│           Infrastructure Layer      │
│  (API, Local Storage, External)     │
└─────────────────────────────────────┘
```

### 3. Dependency Injection
- **Provider Pattern**: Using `MultiBlocProvider` for dependency injection
- **Service Locator**: Centralized service management
- **Singleton Services**: Shared services like `StorageService`, `ApiService`

---

## 🔄 State Management

### BLoC/Cubit Pattern
- **BLoC**: For complex state management with multiple events
- **Cubit**: For simpler state management with direct method calls
- **Events**: Input to the BLoC (user actions, system events)
- **States**: Output from the BLoC (UI state representation)

### BLoC Structure Template
```dart
// events.dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadFeature extends FeatureEvent {}
class UpdateFeature extends FeatureEvent {
  final String data;
  const UpdateFeature(this.data);
  
  @override
  List<Object?> get props => [data];
}

// states.dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final List<Data> data;
  const FeatureLoaded(this.data);
  
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// bloc.dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final ApiService _apiService;
  
  FeatureBloc(this._apiService) : super(FeatureInitial()) {
    on<LoadFeature>(_onLoadFeature);
    on<UpdateFeature>(_onUpdateFeature);
  }
  
  Future<void> _onLoadFeature(LoadFeature event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    try {
      final data = await _apiService.getFeatureData();
      emit(FeatureLoaded(data));
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

### State Management Guidelines
1. **Single Source of Truth**: Each feature has one BLoC
2. **Immutable States**: States should be immutable and use `Equatable`
3. **Event-Driven**: All state changes happen through events
4. **Error Handling**: Always handle errors and emit error states
5. **Loading States**: Provide loading states for better UX

---

## 🧭 Navigation

### GoRouter Configuration
- **Declarative Routes**: All routes defined in `app_router.dart`
- **Type Safety**: Route parameters are type-safe
- **Deep Linking**: Built-in support for deep links
- **Web Support**: Better web navigation experience

### Navigation Patterns
```dart
// Navigate to route
context.go('/profile');

// Navigate with parameters
context.go('/restaurant/123');

// Go back
context.pop();

// Replace current route
context.go('/home', extra: data);
```

### Route Structure
```dart
// app_router.dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    // ... more routes
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);
```

---

## 🌐 Network Layer

### API Service Pattern
- **Retrofit**: For type-safe API calls
- **Dio**: HTTP client with interceptors
- **Error Handling**: Centralized error handling
- **Caching**: Built-in caching support

### API Service Structure
```dart
@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  @GET('/api/v1/profile')
  Future<Response<dynamic>> getProfile();
  
  @PUT('/api/v1/profile')
  Future<Response<dynamic>> updateProfile(@Body() Map<String, dynamic> data);
  
  @POST('/api/v1/wallet/recharge')
  Future<Response<dynamic>> rechargeWallet(@Body() Map<String, dynamic> data);
}
```

### Network Guidelines
1. **Base URL**: Use `AppConstants.baseUrl`
2. **API Versioning**: Include version in URL (`/api/v1/`)
3. **Error Handling**: Handle network errors gracefully
4. **Loading States**: Show loading indicators during API calls
5. **Retry Logic**: Implement retry for failed requests
6. **Offline Support**: Cache data for offline access

---

## 💾 Local Storage

### Storage Strategy
- **SharedPreferences**: For simple key-value storage (settings, tokens)
- **Hive**: For complex object storage (user data, cached data)
- **Encryption**: Sensitive data should be encrypted

### Storage Service Pattern
```dart
class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Token management
  Future<void> setAuthToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }
  
  String? getAuthToken() {
    return _prefs.getString(_tokenKey);
  }
  
  // User data management
  Future<void> setUserData(UserModel user) async {
    final userBox = await Hive.openBox<UserModel>('user_data');
    await userBox.put('current_user', user);
  }
  
  UserModel? getUserData() {
    final userBox = Hive.box<UserModel>('user_data');
    return userBox.get('current_user');
  }
}
```

---

## 🎨 UI/UX Guidelines

### Design System
- **Material Design 3**: Follow Material Design principles
- **Google Fonts**: Use Poppins font family
- **Color Scheme**: Consistent color palette defined in `app_theme.dart`
- **Typography**: Consistent text styles and sizes
- **Spacing**: Use consistent spacing (8px grid system)

### Theme Configuration
```dart
class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  // Text Colors
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      // ... more theme configuration
    );
  }
}
```

### Widget Guidelines
1. **Reusable Components**: Create reusable widgets in `shared/widgets/`
2. **Consistent Styling**: Use theme colors and styles
3. **Responsive Design**: Support different screen sizes
4. **Accessibility**: Include semantic labels and descriptions
5. **Loading States**: Always show loading indicators
6. **Error States**: Provide clear error messages and retry options

---

## 📝 Code Organization

### File Naming Conventions
- **snake_case**: For file names (`profile_page.dart`, `user_model.dart`)
- **PascalCase**: For class names (`ProfilePage`, `UserModel`)
- **camelCase**: For variables and methods (`userName`, `getUserData()`)
- **SCREAMING_SNAKE_CASE**: For constants (`API_BASE_URL`, `DEFAULT_TIMEOUT`)

### Import Organization
```dart
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Third-party imports
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Local imports
import '../bloc/profile_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_widget.dart';
```

### Code Structure Guidelines
1. **Single Responsibility**: Each class/file has one responsibility
2. **Dependency Inversion**: Depend on abstractions, not concretions
3. **Interface Segregation**: Keep interfaces small and focused
4. **Open/Closed Principle**: Open for extension, closed for modification
5. **DRY Principle**: Don't repeat yourself

---

## 🔄 Development Workflow

### Git Workflow
1. **Feature Branches**: Create feature branches from `main`
2. **Branch Naming**: `feature/feature-name` or `fix/issue-description`
3. **Commit Messages**: Use conventional commits
   - `feat: add user profile page`
   - `fix: resolve navigation issue`
   - `docs: update architecture documentation`
4. **Pull Requests**: Require code review before merging
5. **Squash Commits**: Squash commits before merging to main

### Code Review Checklist
- [ ] Code follows project architecture
- [ ] State management follows BLoC pattern
- [ ] Navigation uses GoRouter
- [ ] UI follows design system
- [ ] Error handling is implemented
- [ ] Loading states are provided
- [ ] Tests are written (if applicable)
- [ ] Documentation is updated

### Development Environment Setup
1. **Flutter Version**: 3.7.2+
2. **IDE**: VS Code or Android Studio
3. **Extensions**: Flutter, Dart, BLoC
4. **Code Generation**: Run `flutter packages pub run build_runner build` after model changes
5. **Dependencies**: Run `flutter pub get` after dependency changes

---

## 🧪 Testing Strategy

### Test Types
1. **Unit Tests**: Test individual functions and classes
2. **Widget Tests**: Test UI components
3. **Integration Tests**: Test complete user flows
4. **BLoC Tests**: Test state management logic

### Testing Guidelines
```dart
// BLoC Test Example
group('ProfileBloc', () {
  late ProfileBloc profileBloc;
  late MockApiService mockApiService;
  
  setUp(() {
    mockApiService = MockApiService();
    profileBloc = ProfileBloc(mockApiService);
  });
  
  tearDown(() {
    profileBloc.close();
  });
  
  test('emits [ProfileLoading, ProfileLoaded] when LoadProfile is added', () {
    // Arrange
    when(mockApiService.getProfile()).thenAnswer((_) async => mockUser);
    
    // Act & Assert
    expectLater(
      profileBloc.stream,
      emitsInOrder([
        ProfileLoading(),
        ProfileLoaded(mockUser),
      ]),
    );
    
    profileBloc.add(LoadProfile());
  });
});
```

### Test Coverage Goals
- **Unit Tests**: 80% coverage
- **Widget Tests**: All reusable widgets
- **Integration Tests**: Critical user flows
- **BLoC Tests**: All state management logic

---

## ⚡ Performance Guidelines

### Performance Best Practices
1. **Lazy Loading**: Load data only when needed
2. **Caching**: Cache frequently accessed data
3. **Image Optimization**: Use cached network images
4. **List Optimization**: Use `ListView.builder` for large lists
5. **Memory Management**: Dispose of controllers and streams
6. **Code Splitting**: Split large widgets into smaller components

### Performance Monitoring
- **Flutter Inspector**: Use for performance analysis
- **Memory Profiler**: Monitor memory usage
- **Network Profiler**: Monitor API call performance
- **Frame Rate**: Maintain 60fps

---

## 🔒 Security Guidelines

### Security Best Practices
1. **Token Storage**: Store tokens securely using encrypted storage
2. **Input Validation**: Validate all user inputs
3. **HTTPS Only**: Use HTTPS for all API calls
4. **Error Messages**: Don't expose sensitive information in error messages
5. **Code Obfuscation**: Use code obfuscation for production builds

### Data Protection
- **Personal Data**: Minimize collection and storage of personal data
- **Data Encryption**: Encrypt sensitive data at rest
- **Secure Communication**: Use secure channels for data transmission
- **Access Control**: Implement proper access controls

---

## 🔧 Common Patterns

### Error Handling Pattern
```dart
try {
  final result = await apiService.getData();
  emit(SuccessState(result));
} catch (e) {
  if (e is NetworkException) {
    emit(NetworkErrorState(e.message));
  } else if (e is ServerException) {
    emit(ServerErrorState(e.message));
  } else {
    emit(GenericErrorState('Something went wrong'));
  }
}
```

### Loading State Pattern
```dart
Widget build(BuildContext context) {
  return BlocBuilder<FeatureBloc, FeatureState>(
    builder: (context, state) {
      if (state is FeatureLoading) {
        return const LoadingWidget();
      } else if (state is FeatureLoaded) {
        return _buildContent(state.data);
      } else if (state is FeatureError) {
        return CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<FeatureBloc>().add(LoadFeature()),
        );
      }
      return const SizedBox.shrink();
    },
  );
}
```

### Form Validation Pattern
```dart
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();

Widget build(BuildContext context) {
  return Form(
    key: _formKey,
    child: Column(
      children: [
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Submit form
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}
```

---

## 🛠️ Troubleshooting

### Common Issues

#### Code Generation Issues
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### Navigation Issues
- **Route not found**: Check route definition in `app_router.dart`
- **Parameter issues**: Ensure parameter types match
- **Deep link issues**: Verify route configuration

#### State Management Issues
- **State not updating**: Check if event is properly dispatched
- **Memory leaks**: Ensure BLoC is properly disposed
- **Multiple BLoCs**: Use `BlocProvider.value` for sharing BLoCs

#### Network Issues
- **API errors**: Check API service configuration
- **Timeout issues**: Adjust timeout values in Dio configuration
- **CORS issues**: Ensure backend allows cross-origin requests

### Debug Tools
- **Flutter Inspector**: For widget debugging
- **BLoC Inspector**: For state management debugging
- **Network Inspector**: For API call debugging
- **Performance Profiler**: For performance analysis

---

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Documentation](https://bloclibrary.dev/)
- [GoRouter Documentation](https://gorouter.dev/)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)

### Code Examples
- [Flutter Samples](https://github.com/flutter/samples)
- [BLoC Examples](https://github.com/felangel/bloc/tree/master/examples)
- [GoRouter Examples](https://github.com/flutter/packages/tree/main/packages/go_router/example)

### Best Practices
- [Flutter Best Practices](https://flutter.dev/docs/development/ui/layout/best-practices)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design Guidelines](https://material.io/design)

---

## 🤝 Team Collaboration

### Communication
- **Daily Standups**: Quick status updates
- **Code Reviews**: Thorough review process
- **Architecture Reviews**: For major changes
- **Documentation**: Keep documentation updated

### Code Standards
- **Linting**: Follow Dart/Flutter linting rules
- **Formatting**: Use `dart format` for consistent formatting
- **Comments**: Add comments for complex logic
- **Documentation**: Document public APIs and complex flows

### Knowledge Sharing
- **Code Reviews**: Share knowledge through reviews
- **Pair Programming**: For complex features
- **Documentation**: Maintain up-to-date documentation
- **Training Sessions**: Regular team training

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: Development Team 