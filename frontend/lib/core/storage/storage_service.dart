import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/user_model.dart';
import '../constants/app_constants.dart';

class StorageService {
  static const String _userBox = 'user_box';
  static const String _walletBox = 'wallet_box';
  static const String _favoritesBox = 'favorites_box';
  static const String _settingsBox = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    // Hive.registerAdapter(UserModelAdapter());
    // Hive.registerAdapter(WalletModelAdapter());
    // Hive.registerAdapter(FavoriteRestaurantModelAdapter());
    // Hive.registerAdapter(FavoriteMenuItemModelAdapter());
    
    // Open boxes
    await Hive.openBox(_userBox);
    await Hive.openBox(_walletBox);
    await Hive.openBox(_favoritesBox);
    await Hive.openBox(_settingsBox);
  }

  // SharedPreferences methods
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Auth token methods
  static Future<void> setAuthToken(String token) async {
    await setString(AppConstants.tokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    return await getString(AppConstants.tokenKey);
  }

  static Future<void> removeAuthToken() async {
    await remove(AppConstants.tokenKey);
  }

  // User data methods
  static Future<void> setUserData(UserModel user) async {
    final userBox = Hive.box(_userBox);
    await userBox.put('current_user', user.toJson());
  }

  static Future<UserModel?> getUserData() async {
    final userBox = Hive.box(_userBox);
    final userJson = userBox.get('current_user');
    if (userJson != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userJson));
    }
    return null;
  }

  static Future<void> removeUserData() async {
    final userBox = Hive.box(_userBox);
    await userBox.delete('current_user');
  }

  // Settings methods
  static Future<void> setThemeMode(String themeMode) async {
    await setString(AppConstants.themeKey, themeMode);
  }

  static Future<String> getThemeMode() async {
    return await getString(AppConstants.themeKey) ?? 'system';
  }

  static Future<void> setLanguage(String language) async {
    await setString(AppConstants.languageKey, language);
  }

  static Future<String> getLanguage() async {
    return await getString(AppConstants.languageKey) ?? 'en';
  }

  // Cache methods
  static Future<void> cacheData(String key, Map<String, dynamic> data) async {
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.put(key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getCachedData(String key) async {
    final settingsBox = Hive.box(_settingsBox);
    final data = settingsBox.get(key);
    if (data != null) {
      return Map<String, dynamic>.from(jsonDecode(data));
    }
    return null;
  }

  static Future<void> removeCachedData(String key) async {
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.delete(key);
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await clear();
    await Hive.box(_userBox).clear();
    await Hive.box(_walletBox).clear();
    await Hive.box(_favoritesBox).clear();
    await Hive.box(_settingsBox).clear();
  }
} 