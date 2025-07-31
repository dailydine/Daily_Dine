import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/1profile/pages/profile_page.dart';
import '../../features/1profile/pages/edit_profile_page.dart';
import '../../features/2wallet/pages/wallet_page.dart';
import '../../features/4favorites/pages/favorites_page.dart';
import '../../features/5my_coupons/pages/my_coupons_page.dart';
import '../../features/6my_orders/pages/my_orders_page.dart';
import '../../features/7settings/pages/settings_page.dart';
// import '../../features/home/pages/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/profile',
    routes: [
      // Profile Routes (set as initial route)
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // Home Route (redirect to profile for now)
      GoRoute(
        path: '/',
        name: 'home',
        redirect: (context, state) => '/profile',
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      
      // My Orders Routes
      GoRoute(
        path: '/my-orders',
        name: 'my-orders',
        builder: (context, state) => const MyOrdersPage(),
      ),
      

      
      // Settings Routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      
      // Wallet Routes
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletPage(),
      ),
      
      // Favorites Routes
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      
      // My Coupons Routes
      GoRoute(
        path: '/my-coupons',
        name: 'my-coupons',
        builder: (context, state) => const MyCouponsPage(),
      ),
      
      // Restaurant Routes
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant-details',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return RestaurantDetailsPage(restaurantId: restaurantId);
        },
      ),
      
      // Menu Item Routes
      GoRoute(
        path: '/menu-item/:id',
        name: 'menu-item-details',
        builder: (context, state) {
          final menuItemId = state.pathParameters['id']!;
          return MenuItemDetailsPage(menuItemId: menuItemId);
        },
      ),
      
      // Booking Routes
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const BookingPage(),
      ),
      
      // Order Routes
      GoRoute(
        path: '/order',
        name: 'order',
        builder: (context, state) => const OrderPage(),
      ),
      
      // QR Scanner Routes (commented out for now)
      // GoRoute(
      //   path: '/qr-scanner',
      //   name: 'qr-scanner',
      //   builder: (context, state) => const QRScannerPage(),
      // ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

// Placeholder pages for routes that haven't been implemented yet

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
      ),
      body: Center(
        child: Text('Restaurant Details Page - ID: $restaurantId'),
      ),
    );
  }
}

class MenuItemDetailsPage extends StatelessWidget {
  final String menuItemId;

  const MenuItemDetailsPage({super.key, required this.menuItemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Item Details'),
      ),
      body: Center(
        child: Text('Menu Item Details Page - ID: $menuItemId'),
      ),
    );
  }
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Table'),
      ),
      body: const Center(
        child: Text('Booking Page - Coming Soon'),
      ),
    );
  }
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: const Center(
        child: Text('Order Page - Coming Soon'),
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: const Center(
        child: Text('QR Scanner Page - Coming Soon'),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
} 