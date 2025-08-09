import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/1profile/bloc/profile_bloc.dart';
import 'features/2wallet/bloc/wallet_bloc.dart';
import 'features/4favorites/bloc/favorites_bloc.dart';
import 'features/5my_coupons/bloc/coupons_bloc.dart';
import 'features/6my_orders/bloc/orders_bloc.dart';
import 'features/7settings/bloc/settings_bloc.dart';
import 'features/home/bloc/home_bloc.dart';

void main() {
  runApp(const DailyDineApp());
}

class DailyDineApp extends StatelessWidget {
  const DailyDineApp({super.key});

  @override
  Widget build(BuildContext context) {
            return MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc()..add(const LoadProfile()),
            ),
            BlocProvider<WalletBloc>(
              create: (context) => WalletBloc()..add(const LoadWallet()),
            ),
            BlocProvider<FavoritesBloc>(
              create: (context) => FavoritesBloc()..add(const LoadFavorites()),
            ),
            BlocProvider<CouponsBloc>(
              create: (context) => CouponsBloc()..add(const LoadCoupons()),
            ),
            BlocProvider<SettingsBloc>(
              create: (context) => SettingsBloc()..add(const LoadSettings()),
            ),
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc()..add(const LoadHomeData()),
            ),
            BlocProvider<OrdersBloc>(
              create: (context) => OrdersBloc()..add(const LoadOrders()),
            ),
          ],
      child: MaterialApp.router(
        title: 'DailyDine',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
