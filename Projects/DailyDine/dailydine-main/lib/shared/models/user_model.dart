import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatar;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double walletBalance;
  final int totalOrders;
  final int totalBookings;
  final List<String> favoriteRestaurants;
  final List<String> favoriteMenuItems;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.dateOfBirth,
    this.gender,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.walletBalance,
    required this.totalOrders,
    required this.totalBookings,
    required this.favoriteRestaurants,
    required this.favoriteMenuItems,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';
  String get displayName => firstName.isNotEmpty ? firstName : email.split('@').first;
  String get fullDisplayName => '$firstName $lastName'.trim();
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatar,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? dateOfBirth,
    String? gender,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? walletBalance,
    int? totalOrders,
    int? totalBookings,
    List<String>? favoriteRestaurants,
    List<String>? favoriteMenuItems,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walletBalance: walletBalance ?? this.walletBalance,
      totalOrders: totalOrders ?? this.totalOrders,
      totalBookings: totalBookings ?? this.totalBookings,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      favoriteMenuItems: favoriteMenuItems ?? this.favoriteMenuItems,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phoneNumber,
    avatar,
    address,
    city,
    state,
    zipCode,
    country,
    dateOfBirth,
    gender,
    isEmailVerified,
    isPhoneVerified,
    createdAt,
    updatedAt,
    walletBalance,
    totalOrders,
    totalBookings,
    favoriteRestaurants,
    favoriteMenuItems,
  ];
} 