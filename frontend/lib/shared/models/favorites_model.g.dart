// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteRestaurantModel _$FavoriteRestaurantModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteRestaurantModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      restaurantImage: json['restaurantImage'] as String?,
      restaurantAddress: json['restaurantAddress'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      cuisine: json['cuisine'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$FavoriteRestaurantModelToJson(
        FavoriteRestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'restaurantImage': instance.restaurantImage,
      'restaurantAddress': instance.restaurantAddress,
      'rating': instance.rating,
      'cuisine': instance.cuisine,
      'addedAt': instance.addedAt.toIso8601String(),
    };

FavoriteMenuItemModel _$FavoriteMenuItemModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteMenuItemModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      menuItemId: json['menuItemId'] as String,
      menuItemName: json['menuItemName'] as String,
      menuItemImage: json['menuItemImage'] as String?,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$FavoriteMenuItemModelToJson(
        FavoriteMenuItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'menuItemId': instance.menuItemId,
      'menuItemName': instance.menuItemName,
      'menuItemImage': instance.menuItemImage,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'addedAt': instance.addedAt.toIso8601String(),
    };
