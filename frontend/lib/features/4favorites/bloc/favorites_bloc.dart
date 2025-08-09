import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddToFavorites extends FavoritesEvent {
  final String itemId;
  final String itemName;
  final String itemType; // 'restaurant' or 'menu_item'
  final String? imageUrl;
  final String? description;
  final double? price;

  const AddToFavorites({
    required this.itemId,
    required this.itemName,
    required this.itemType,
    this.imageUrl,
    this.description,
    this.price,
  });

  @override
  List<Object?> get props => [itemId, itemName, itemType, imageUrl, description, price];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String itemId;

  const RemoveFromFavorites(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearFavorites extends FavoritesEvent {
  const ClearFavorites();
}

class ToggleFavorite extends FavoritesEvent {
  final String itemId;
  final String itemName;
  final String itemType;
  final String? imageUrl;
  final String? description;
  final double? price;

  const ToggleFavorite({
    required this.itemId,
    required this.itemName,
    required this.itemType,
    this.imageUrl,
    this.description,
    this.price,
  });

  @override
  List<Object?> get props => [itemId, itemName, itemType, imageUrl, description, price];
}

// States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> favoriteRestaurants;
  final List<FavoriteItem> favoriteMenuItems;

  const FavoritesLoaded({
    required this.favoriteRestaurants,
    required this.favoriteMenuItems,
  });

  @override
  List<Object?> get props => [favoriteRestaurants, favoriteMenuItems];

  FavoritesLoaded copyWith({
    List<FavoriteItem>? favoriteRestaurants,
    List<FavoriteItem>? favoriteMenuItems,
  }) {
    return FavoritesLoaded(
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      favoriteMenuItems: favoriteMenuItems ?? this.favoriteMenuItems,
    );
  }

  List<FavoriteItem> get allFavorites => [...favoriteRestaurants, ...favoriteMenuItems];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock favorites data (empty initially)
      final favoriteRestaurants = <FavoriteItem>[];
      final favoriteMenuItems = <FavoriteItem>[];

      emit(FavoritesLoaded(
        favoriteRestaurants: favoriteRestaurants,
        favoriteMenuItems: favoriteMenuItems,
      ));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: $e'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final newFavorite = FavoriteItem(
          id: event.itemId,
          name: event.itemName,
          type: event.itemType,
          imageUrl: event.imageUrl,
          description: event.description,
          price: event.price,
          addedAt: DateTime.now(),
        );

        List<FavoriteItem> updatedRestaurants = List.from(currentState.favoriteRestaurants);
        List<FavoriteItem> updatedMenuItems = List.from(currentState.favoriteMenuItems);

        if (event.itemType == 'restaurant') {
          // Check if already exists
          if (!updatedRestaurants.any((item) => item.id == event.itemId)) {
            updatedRestaurants.add(newFavorite);
          }
        } else if (event.itemType == 'menu_item') {
          // Check if already exists
          if (!updatedMenuItems.any((item) => item.id == event.itemId)) {
            updatedMenuItems.add(newFavorite);
          }
        }

        emit(currentState.copyWith(
          favoriteRestaurants: updatedRestaurants,
          favoriteMenuItems: updatedMenuItems,
        ));
      }
    } catch (e) {
      emit(FavoritesError('Failed to add to favorites: $e'));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedRestaurants = currentState.favoriteRestaurants
            .where((item) => item.id != event.itemId)
            .toList();
        final updatedMenuItems = currentState.favoriteMenuItems
            .where((item) => item.id != event.itemId)
            .toList();

        emit(currentState.copyWith(
          favoriteRestaurants: updatedRestaurants,
          favoriteMenuItems: updatedMenuItems,
        ));
      }
    } catch (e) {
      emit(FavoritesError('Failed to remove from favorites: $e'));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        emit(currentState.copyWith(
          favoriteRestaurants: [],
          favoriteMenuItems: [],
        ));
      }
    } catch (e) {
      emit(FavoritesError('Failed to clear favorites: $e'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        // Check if item is already in favorites
        final isRestaurant = currentState.favoriteRestaurants.any((item) => item.id == event.itemId);
        final isMenuItem = currentState.favoriteMenuItems.any((item) => item.id == event.itemId);

        if (isRestaurant || isMenuItem) {
          // Remove from favorites
          add(RemoveFromFavorites(event.itemId));
        } else {
          // Add to favorites
          add(AddToFavorites(
            itemId: event.itemId,
            itemName: event.itemName,
            itemType: event.itemType,
            imageUrl: event.imageUrl,
            description: event.description,
            price: event.price,
          ));
        }
      }
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: $e'));
    }
  }
}

// Additional model for favorite items
class FavoriteItem {
  final String id;
  final String name;
  final String type; // 'restaurant' or 'menu_item'
  final String? imageUrl;
  final String? description;
  final double? price;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.type,
    this.imageUrl,
    this.description,
    this.price,
    required this.addedAt,
  });

  FavoriteItem copyWith({
    String? id,
    String? name,
    String? type,
    String? imageUrl,
    String? description,
    double? price,
    DateTime? addedAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
