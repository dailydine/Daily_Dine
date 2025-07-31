import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class AddOrder extends OrdersEvent {
  final OrderItem order;

  const AddOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}

class RateOrder extends OrdersEvent {
  final String orderId;
  final double rating;
  final String? review;

  const RateOrder({
    required this.orderId,
    required this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [orderId, rating, review];
}

class CancelOrder extends OrdersEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// States
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderItem> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];

  OrdersLoaded copyWith({List<OrderItem>? orders}) {
    return OrdersLoaded(orders: orders ?? this.orders);
  }
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<AddOrder>(_onAddOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<RateOrder>(_onRateOrder);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock orders data (empty initially)
      final orders = <OrderItem>[];

      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }

  Future<void> _onAddOrder(
    AddOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders = [event.order, ...currentState.orders];
        emit(currentState.copyWith(orders: updatedOrders));
      }
    } catch (e) {
      emit(OrdersError('Failed to add order: $e'));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(status: event.status);
          }
          return order;
        }).toList();

        emit(currentState.copyWith(orders: updatedOrders));
      }
    } catch (e) {
      emit(OrdersError('Failed to update order status: $e'));
    }
  }

  Future<void> _onRateOrder(
    RateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(
              rating: event.rating,
              review: event.review,
              isRated: true,
            );
          }
          return order;
        }).toList();

        emit(currentState.copyWith(orders: updatedOrders));
      }
    } catch (e) {
      emit(OrdersError('Failed to rate order: $e'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(status: 'cancelled');
          }
          return order;
        }).toList();

        emit(currentState.copyWith(orders: updatedOrders));
      }
    } catch (e) {
      emit(OrdersError('Failed to cancel order: $e'));
    }
  }
}

// Order model
class OrderItem {
  final String id;
  final String restaurantName;
  final String restaurantImage;
  final List<OrderMenuItem> items;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? deliveryAddress;
  final double? rating;
  final String? review;
  final bool isRated;

  OrderItem({
    required this.id,
    required this.restaurantName,
    required this.restaurantImage,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.deliveryAddress,
    this.rating,
    this.review,
    this.isRated = false,
  });

  OrderItem copyWith({
    String? id,
    String? restaurantName,
    String? restaurantImage,
    List<OrderMenuItem>? items,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? deliveryAddress,
    double? rating,
    String? review,
    bool? isRated,
  }) {
    return OrderItem(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      isRated: isRated ?? this.isRated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class OrderMenuItem {
  final String id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderMenuItem({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  OrderMenuItem copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? specialInstructions,
  }) {
    return OrderMenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  double get totalPrice => price * quantity;
} 