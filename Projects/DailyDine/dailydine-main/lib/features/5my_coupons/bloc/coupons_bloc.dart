import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CouponsEvent extends Equatable {
  const CouponsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoupons extends CouponsEvent {
  const LoadCoupons();
}

class AddCoupon extends CouponsEvent {
  final Coupon coupon;

  const AddCoupon(this.coupon);

  @override
  List<Object?> get props => [coupon];
}

class UseCoupon extends CouponsEvent {
  final String couponId;

  const UseCoupon(this.couponId);

  @override
  List<Object?> get props => [couponId];
}

class RemoveCoupon extends CouponsEvent {
  final String couponId;

  const RemoveCoupon(this.couponId);

  @override
  List<Object?> get props => [couponId];
}

class ValidateCoupon extends CouponsEvent {
  final String couponCode;

  const ValidateCoupon(this.couponCode);

  @override
  List<Object?> get props => [couponCode];
}

// States
abstract class CouponsState extends Equatable {
  const CouponsState();

  @override
  List<Object?> get props => [];
}

class CouponsInitial extends CouponsState {}

class CouponsLoading extends CouponsState {}

class CouponsLoaded extends CouponsState {
  final List<Coupon> coupons;

  const CouponsLoaded({required this.coupons});

  @override
  List<Object?> get props => [coupons];

  CouponsLoaded copyWith({List<Coupon>? coupons}) {
    return CouponsLoaded(coupons: coupons ?? this.coupons);
  }
}

class CouponsError extends CouponsState {
  final String message;

  const CouponsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class CouponsBloc extends Bloc<CouponsEvent, CouponsState> {
  CouponsBloc() : super(CouponsInitial()) {
    on<LoadCoupons>(_onLoadCoupons);
    on<AddCoupon>(_onAddCoupon);
    on<UseCoupon>(_onUseCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<ValidateCoupon>(_onValidateCoupon);
  }

  Future<void> _onLoadCoupons(
    LoadCoupons event,
    Emitter<CouponsState> emit,
  ) async {
    emit(CouponsLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock coupons data (empty initially)
      final coupons = <Coupon>[];

      emit(CouponsLoaded(coupons: coupons));
    } catch (e) {
      emit(CouponsError('Failed to load coupons: $e'));
    }
  }

  Future<void> _onAddCoupon(
    AddCoupon event,
    Emitter<CouponsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CouponsLoaded) {
        // Check if coupon already exists
        if (!currentState.coupons.any((coupon) => coupon.id == event.coupon.id)) {
          final updatedCoupons = [event.coupon, ...currentState.coupons];
          emit(currentState.copyWith(coupons: updatedCoupons));
        }
      }
    } catch (e) {
      emit(CouponsError('Failed to add coupon: $e'));
    }
  }

  Future<void> _onUseCoupon(
    UseCoupon event,
    Emitter<CouponsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CouponsLoaded) {
        final updatedCoupons = currentState.coupons.map((coupon) {
          if (coupon.id == event.couponId) {
            return coupon.copyWith(isUsed: true, usedAt: DateTime.now());
          }
          return coupon;
        }).toList();

        emit(currentState.copyWith(coupons: updatedCoupons));
      }
    } catch (e) {
      emit(CouponsError('Failed to use coupon: $e'));
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCoupon event,
    Emitter<CouponsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CouponsLoaded) {
        final updatedCoupons = currentState.coupons
            .where((coupon) => coupon.id != event.couponId)
            .toList();

        emit(currentState.copyWith(coupons: updatedCoupons));
      }
    } catch (e) {
      emit(CouponsError('Failed to remove coupon: $e'));
    }
  }

  Future<void> _onValidateCoupon(
    ValidateCoupon event,
    Emitter<CouponsState> emit,
  ) async {
    try {
      // Simulate API call to validate coupon code
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock validation logic
      if (event.couponCode.isNotEmpty) {
        // In real app, this would call an API to validate the coupon
        // For now, we'll just emit success
        emit(CouponsLoaded(coupons: []));
      } else {
        emit(CouponsError('Invalid coupon code'));
      }
    } catch (e) {
      emit(CouponsError('Failed to validate coupon: $e'));
    }
  }
}

// Coupon model
class Coupon {
  final String id;
  final String code;
  final String title;
  final String description;
  final double discountAmount;
  final String discountType; // 'percentage' or 'fixed'
  final double minimumOrderAmount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isUsed;
  final DateTime? usedAt;
  final String? restaurantId; // null for general coupons
  final String? category; // 'food', 'delivery', 'general'

  Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountAmount,
    required this.discountType,
    required this.minimumOrderAmount,
    required this.validFrom,
    required this.validUntil,
    this.isUsed = false,
    this.usedAt,
    this.restaurantId,
    this.category,
  });

  Coupon copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    double? discountAmount,
    String? discountType,
    double? minimumOrderAmount,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isUsed,
    DateTime? usedAt,
    String? restaurantId,
    String? category,
  }) {
    return Coupon(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountAmount: discountAmount ?? this.discountAmount,
      discountType: discountType ?? this.discountType,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt ?? this.usedAt,
      restaurantId: restaurantId ?? this.restaurantId,
      category: category ?? this.category,
    );
  }

  bool get isValid => DateTime.now().isAfter(validFrom) && DateTime.now().isBefore(validUntil);
  bool get isExpired => DateTime.now().isAfter(validUntil);
  bool get canBeUsed => isValid && !isUsed;

  String get discountText {
    if (discountType == 'percentage') {
      return '${discountAmount.toInt()}% OFF';
    } else {
      return '\$${discountAmount.toStringAsFixed(2)} OFF';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Coupon && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 