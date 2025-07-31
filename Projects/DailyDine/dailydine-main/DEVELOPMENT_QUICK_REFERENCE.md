# DailyDine - Development Quick Reference

## 🚀 Quick Start Commands

```bash
# Setup project
flutter pub get
flutter packages pub run build_runner build

# Run app
flutter run

# Generate code after model changes
flutter packages pub run build_runner build --delete-conflicting-outputs

# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build
```

## 📁 File Structure Quick Reference

```
lib/
├── core/                    # Core app layer
│   ├── constants/          # App constants
│   ├── network/            # API services
│   ├── routes/             # Navigation
│   ├── storage/            # Local storage
│   └── theme/              # App theming
├── features/               # Feature modules
│   └── feature_name/
│       ├── bloc/           # State management
│       ├── pages/          # UI pages
│       └── widgets/        # Feature widgets
└── shared/                 # Shared components
    ├── models/             # Data models
    ├── widgets/            # Reusable widgets
    └── utils/              # Utilities
```

## 🔄 Common Patterns

### BLoC Pattern
```dart
// Event
class LoadData extends FeatureEvent {}

// State
class FeatureLoaded extends FeatureState {
  final List<Data> data;
  const FeatureLoaded(this.data);
}

// BLoC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc() : super(FeatureInitial()) {
    on<LoadData>(_onLoadData);
  }
  
  Future<void> _onLoadData(LoadData event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    try {
      final data = await apiService.getData();
      emit(FeatureLoaded(data));
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

### Page Structure
```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feature')),
      body: BlocBuilder<FeatureBloc, FeatureState>(
        builder: (context, state) {
          if (state is FeatureLoading) return LoadingWidget();
          if (state is FeatureLoaded) return _buildContent(state.data);
          if (state is FeatureError) return CustomErrorWidget(message: state.message);
          return SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Navigation
```dart
// Navigate
context.go('/profile');

// Navigate with data
context.go('/restaurant/123', extra: data);

// Go back
context.pop();

// Replace route
context.go('/home');
```

### API Service
```dart
@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  @GET('/api/v1/endpoint')
  Future<Response<dynamic>> getData();
  
  @POST('/api/v1/endpoint')
  Future<Response<dynamic>> postData(@Body() Map<String, dynamic> data);
}
```

### Model with JSON Serialization
```dart
@JsonSerializable()
class DataModel extends Equatable {
  final String id;
  final String name;
  
  const DataModel({required this.id, required this.name});
  
  factory DataModel.fromJson(Map<String, dynamic> json) => _$DataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DataModelToJson(this);
  
  @override
  List<Object?> get props => [id, name];
}
```

## 🎨 UI Guidelines

### Colors
```dart
// Use theme colors
AppTheme.primaryColor
AppTheme.secondaryColor
AppTheme.backgroundColor
AppTheme.errorColor
AppTheme.successColor
```

### Text Styles
```dart
// Use theme text styles
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.labelSmall
```

### Common Widgets
```dart
// Loading
LoadingWidget()

// Error
CustomErrorWidget(message: 'Error message', onRetry: () {})

// Empty state
EmptyStateWidget(
  icon: Icons.inbox,
  title: 'No Data',
  message: 'No items found',
)
```

## 📝 Code Standards

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`

### Import Order
```dart
// 1. Flutter imports
import 'package:flutter/material.dart';

// 2. Third-party imports
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Local imports
import '../bloc/feature_bloc.dart';
```

### Error Handling
```dart
try {
  final result = await apiService.getData();
  emit(SuccessState(result));
} catch (e) {
  if (e is NetworkException) {
    emit(NetworkErrorState(e.message));
  } else {
    emit(GenericErrorState('Something went wrong'));
  }
}
```

## 🔧 Common Tasks

### Add New Feature
1. Create feature folder: `lib/features/feature_name/`
2. Add BLoC: `bloc/feature_bloc.dart`
3. Add pages: `pages/feature_page.dart`
4. Add route in `app_router.dart`
5. Add BLoC provider in `main.dart`

### Add New Model
1. Create model file: `lib/shared/models/model_name.dart`
2. Add JSON serialization annotations
3. Run code generation: `flutter packages pub run build_runner build`

### Add New API Endpoint
1. Add method to `ApiService`
2. Add Retrofit annotations
3. Run code generation: `flutter packages pub run build_runner build`

### Add New Widget
1. Create widget file in appropriate location
2. Follow widget naming convention
3. Add proper documentation
4. Add tests if reusable

## 🐛 Debugging

### Common Issues
- **Code generation errors**: Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
- **Navigation issues**: Check route definition in `app_router.dart`
- **State not updating**: Verify BLoC event dispatch
- **API errors**: Check network configuration and error handling

### Debug Tools
- **Flutter Inspector**: Widget debugging
- **BLoC Inspector**: State management debugging
- **Network Inspector**: API call debugging

## 📋 Checklist for New Features

- [ ] Feature folder structure created
- [ ] BLoC implemented with proper events/states
- [ ] UI pages created with loading/error states
- [ ] Navigation route added
- [ ] API service methods added
- [ ] Models created with JSON serialization
- [ ] Error handling implemented
- [ ] Loading states provided
- [ ] Code follows naming conventions
- [ ] Documentation updated
- [ ] Tests written (if applicable)

## 🚨 Emergency Contacts

- **Architecture Issues**: Check `ARCHITECTURE.md`
- **Code Generation Issues**: Run build_runner commands
- **Navigation Issues**: Check `app_router.dart`
- **State Management Issues**: Check BLoC implementation
- **UI Issues**: Check theme and design system

---

**Remember**: Always follow the established patterns and consult the full `ARCHITECTURE.md` for detailed guidelines! 