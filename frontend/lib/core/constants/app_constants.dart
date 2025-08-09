class AppConstants {
  // App Info
  static const String appName = 'DailyDine';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.dailydine.com'; // Replace with actual API URL
  static const String apiVersion = '/api/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Configuration
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultRestaurantImage = 'assets/images/default_restaurant.png';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  
  // Success Messages
  static const String profileUpdated = 'Profile updated successfully!';
  static const String walletRecharged = 'Wallet recharged successfully!';
  static const String itemAddedToFavorites = 'Added to favorites!';
  static const String itemRemovedFromFavorites = 'Removed from favorites!';
} 