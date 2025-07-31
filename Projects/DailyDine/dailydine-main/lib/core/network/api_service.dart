import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter/foundation.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/wallet_model.dart';
import '../../shared/models/favorites_model.dart';
import '../constants/app_constants.dart';

part 'api_service.g.dart';

// Simple error logger for retrofit
class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions requestOptions) {
    debugPrint('API Error: $error');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('Request: ${requestOptions.method} ${requestOptions.path}');
  }
}

@RestApi(baseUrl: AppConstants.baseUrl + AppConstants.apiVersion)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl, ParseErrorLogger? errorLogger}) = _ApiService;

  // User endpoints
  @GET('/user/profile')
  Future<UserModel> getUserProfile();

  @PUT('/user/profile')
  Future<UserModel> updateUserProfile(@Body() Map<String, dynamic> profileData);

  // Wallet endpoints
  @GET('/wallet/balance')
  Future<WalletModel> getWalletBalance();

  @GET('/wallet/transactions')
  Future<List<TransactionModel>> getWalletTransactions({
    @Query('page') int page = 1,
    @Query('limit') int limit = AppConstants.defaultPageSize,
  });

  @POST('/wallet/recharge')
  Future<TransactionModel> rechargeWallet(@Body() Map<String, dynamic> rechargeData);

  @POST('/wallet/withdraw')
  Future<TransactionModel> withdrawFromWallet(@Body() Map<String, dynamic> withdrawData);

  // Favorites endpoints
  @GET('/favorites/restaurants')
  Future<List<FavoriteRestaurantModel>> getFavoriteRestaurants({
    @Query('page') int page = 1,
    @Query('limit') int limit = AppConstants.defaultPageSize,
  });

  @POST('/favorites/restaurants')
  Future<FavoriteRestaurantModel> addFavoriteRestaurant(@Body() Map<String, dynamic> restaurantData);

  @DELETE('/favorites/restaurants/{restaurantId}')
  Future<void> removeFavoriteRestaurant(@Path('restaurantId') String restaurantId);

  @GET('/favorites/menu-items')
  Future<List<FavoriteMenuItemModel>> getFavoriteMenuItems({
    @Query('page') int page = 1,
    @Query('limit') int limit = AppConstants.defaultPageSize,
  });

  @POST('/favorites/menu-items')
  Future<FavoriteMenuItemModel> addFavoriteMenuItem(@Body() Map<String, dynamic> menuItemData);

  @DELETE('/favorites/menu-items/{menuItemId}')
  Future<void> removeFavoriteMenuItem(@Path('menuItemId') String menuItemId);
}

class ApiClient {
  static Dio createDio() {
    final dio = Dio();
    
    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
    
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        // options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        // Handle common errors
        handler.next(error);
      },
    ));
    
    return dio;
  }
} 