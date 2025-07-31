import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorites_model.g.dart';

@JsonSerializable()
class FavoriteRestaurantModel extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImage;
  final String? restaurantAddress;
  final double? rating;
  final String? cuisine;
  final DateTime addedAt;

  const FavoriteRestaurantModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantImage,
    this.restaurantAddress,
    this.rating,
    this.cuisine,
    required this.addedAt,
  });

  factory FavoriteRestaurantModel.fromJson(Map<String, dynamic> json) => _$FavoriteRestaurantModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteRestaurantModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    restaurantImage,
    restaurantAddress,
    rating,
    cuisine,
    addedAt,
  ];
}

@JsonSerializable()
class FavoriteMenuItemModel extends Equatable {
  final String id;
  final String userId;
  final String menuItemId;
  final String menuItemName;
  final String? menuItemImage;
  final String restaurantId;
  final String restaurantName;
  final double? price;
  final String? description;
  final String? category;
  final DateTime addedAt;

  const FavoriteMenuItemModel({
    required this.id,
    required this.userId,
    required this.menuItemId,
    required this.menuItemName,
    this.menuItemImage,
    required this.restaurantId,
    required this.restaurantName,
    this.price,
    this.description,
    this.category,
    required this.addedAt,
  });

  factory FavoriteMenuItemModel.fromJson(Map<String, dynamic> json) => _$FavoriteMenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteMenuItemModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    menuItemId,
    menuItemName,
    menuItemImage,
    restaurantId,
    restaurantName,
    price,
    description,
    category,
    addedAt,
  ];
} 