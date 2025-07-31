import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class SearchRestaurants extends HomeEvent {
  final String query;
  final String? location;
  final String? cuisine;
  final double? rating;
  final bool? isVegOnly;

  const SearchRestaurants({
    required this.query,
    this.location,
    this.cuisine,
    this.rating,
    this.isVegOnly,
  });

  @override
  List<Object?> get props => [query, location, cuisine, rating, isVegOnly];
}

class LoadNearbyRestaurants extends HomeEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadNearbyRestaurants({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0, // 5km default
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class LoadPopularRestaurants extends HomeEvent {
  const LoadPopularRestaurants();
}

class LoadRecommendedRestaurants extends HomeEvent {
  const LoadRecommendedRestaurants();
}

class UpdateLocation extends HomeEvent {
  final String location;

  const UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class ToggleVegMode extends HomeEvent {
  const ToggleVegMode();
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Restaurant> nearbyRestaurants;
  final List<Restaurant> popularRestaurants;
  final List<Restaurant> recommendedRestaurants;
  final List<Restaurant> searchResults;
  final String currentLocation;
  final bool isVegMode;
  final bool isSearching;

  const HomeLoaded({
    required this.nearbyRestaurants,
    required this.popularRestaurants,
    required this.recommendedRestaurants,
    required this.searchResults,
    required this.currentLocation,
    required this.isVegMode,
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [
    nearbyRestaurants,
    popularRestaurants,
    recommendedRestaurants,
    searchResults,
    currentLocation,
    isVegMode,
    isSearching,
  ];

  HomeLoaded copyWith({
    List<Restaurant>? nearbyRestaurants,
    List<Restaurant>? popularRestaurants,
    List<Restaurant>? recommendedRestaurants,
    List<Restaurant>? searchResults,
    String? currentLocation,
    bool? isVegMode,
    bool? isSearching,
  }) {
    return HomeLoaded(
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      popularRestaurants: popularRestaurants ?? this.popularRestaurants,
      recommendedRestaurants: recommendedRestaurants ?? this.recommendedRestaurants,
      searchResults: searchResults ?? this.searchResults,
      currentLocation: currentLocation ?? this.currentLocation,
      isVegMode: isVegMode ?? this.isVegMode,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<LoadNearbyRestaurants>(_onLoadNearbyRestaurants);
    on<LoadPopularRestaurants>(_onLoadPopularRestaurants);
    on<LoadRecommendedRestaurants>(_onLoadRecommendedRestaurants);
    on<UpdateLocation>(_onUpdateLocation);
    on<ToggleVegMode>(_onToggleVegMode);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock home data
      final nearbyRestaurants = <Restaurant>[];
      final popularRestaurants = <Restaurant>[];
      final recommendedRestaurants = <Restaurant>[];
      final searchResults = <Restaurant>[];

      emit(HomeLoaded(
        nearbyRestaurants: nearbyRestaurants,
        popularRestaurants: popularRestaurants,
        recommendedRestaurants: recommendedRestaurants,
        searchResults: searchResults,
        currentLocation: 'Current Location',
        isVegMode: false,
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        // Simulate search delay
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Mock search results
        final searchResults = <Restaurant>[];
        
        // In real app, this would filter based on search criteria
        if (event.query.isNotEmpty) {
          // Filter restaurants based on search criteria
          final allRestaurants = [
            ...currentState.nearbyRestaurants,
            ...currentState.popularRestaurants,
            ...currentState.recommendedRestaurants,
          ];
          
          // Mock filtering logic
          searchResults.addAll(allRestaurants.where((restaurant) {
            final matchesQuery = restaurant.name.toLowerCase().contains(event.query.toLowerCase()) ||
                               restaurant.cuisine.toLowerCase().contains(event.query.toLowerCase());
            final matchesVeg = event.isVegOnly == null || !event.isVegOnly! || restaurant.isVegFriendly;
            final matchesRating = event.rating == null || restaurant.rating >= event.rating!;
            
            return matchesQuery && matchesVeg && matchesRating;
          }));
        }

        emit(currentState.copyWith(
          searchResults: searchResults,
          isSearching: true,
        ));
      }
    } catch (e) {
      emit(HomeError('Failed to search restaurants: $e'));
    }
  }

  Future<void> _onLoadNearbyRestaurants(
    LoadNearbyRestaurants event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Mock nearby restaurants data
        final nearbyRestaurants = <Restaurant>[];

        emit(currentState.copyWith(nearbyRestaurants: nearbyRestaurants));
      }
    } catch (e) {
      emit(HomeError('Failed to load nearby restaurants: $e'));
    }
  }

  Future<void> _onLoadPopularRestaurants(
    LoadPopularRestaurants event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Mock popular restaurants data
        final popularRestaurants = <Restaurant>[];

        emit(currentState.copyWith(popularRestaurants: popularRestaurants));
      }
    } catch (e) {
      emit(HomeError('Failed to load popular restaurants: $e'));
    }
  }

  Future<void> _onLoadRecommendedRestaurants(
    LoadRecommendedRestaurants event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Mock recommended restaurants data
        final recommendedRestaurants = <Restaurant>[];

        emit(currentState.copyWith(recommendedRestaurants: recommendedRestaurants));
      }
    } catch (e) {
      emit(HomeError('Failed to load recommended restaurants: $e'));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(currentLocation: event.location));
      }
    } catch (e) {
      emit(HomeError('Failed to update location: $e'));
    }
  }

  Future<void> _onToggleVegMode(
    ToggleVegMode event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(isVegMode: !currentState.isVegMode));
      }
    } catch (e) {
      emit(HomeError('Failed to toggle veg mode: $e'));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Reload all home data
      add(const LoadHomeData());
    } catch (e) {
      emit(HomeError('Failed to refresh home data: $e'));
    }
  }
}

// Restaurant model
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String image;
  final double rating;
  final int reviewCount;
  final String deliveryTime; // e.g., "30-45 min"
  final double deliveryFee;
  final double minimumOrder;
  final bool isVegFriendly;
  final bool isOpen;
  final String address;
  final double? distance; // in km
  final List<String> tags; // e.g., ["Fast Food", "Budget Friendly"]

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isVegFriendly,
    required this.isOpen,
    required this.address,
    this.distance,
    required this.tags,
  });

  Restaurant copyWith({
    String? id,
    String? name,
    String? cuisine,
    String? image,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    double? deliveryFee,
    double? minimumOrder,
    bool? isVegFriendly,
    bool? isOpen,
    String? address,
    double? distance,
    List<String>? tags,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      cuisine: cuisine ?? this.cuisine,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      isVegFriendly: isVegFriendly ?? this.isVegFriendly,
      isOpen: isOpen ?? this.isOpen,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 