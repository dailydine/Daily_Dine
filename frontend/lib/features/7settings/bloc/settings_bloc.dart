import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateNotificationSettings extends SettingsEvent {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool promotionalOffers;
  final bool newRestaurants;

  const UpdateNotificationSettings({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.orderUpdates,
    required this.promotionalOffers,
    required this.newRestaurants,
  });

  @override
  List<Object?> get props => [
    pushNotifications,
    emailNotifications,
    smsNotifications,
    orderUpdates,
    promotionalOffers,
    newRestaurants,
  ];
}

class UpdatePrivacySettings extends SettingsEvent {
  final bool shareLocation;
  final bool shareOrderHistory;
  final bool allowAnalytics;

  const UpdatePrivacySettings({
    required this.shareLocation,
    required this.shareOrderHistory,
    required this.allowAnalytics,
  });

  @override
  List<Object?> get props => [shareLocation, shareOrderHistory, allowAnalytics];
}

class UpdateAppSettings extends SettingsEvent {
  final String language;
  final String currency;
  final String theme; // 'light', 'dark', 'system'
  final bool autoLocation;

  const UpdateAppSettings({
    required this.language,
    required this.currency,
    required this.theme,
    required this.autoLocation,
  });

  @override
  List<Object?> get props => [language, currency, theme, autoLocation];
}

class ToggleVegMode extends SettingsEvent {
  const ToggleVegMode();
}

class ClearCache extends SettingsEvent {
  const ClearCache();
}

class ExportData extends SettingsEvent {
  const ExportData();
}

class DeleteAccount extends SettingsEvent {
  const DeleteAccount();
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];

  SettingsLoaded copyWith({AppSettings? settings}) {
    return SettingsLoaded(settings: settings ?? this.settings);
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<UpdatePrivacySettings>(_onUpdatePrivacySettings);
    on<UpdateAppSettings>(_onUpdateAppSettings);
    on<ToggleVegMode>(_onToggleVegMode);
    on<ClearCache>(_onClearCache);
    on<ExportData>(_onExportData);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock settings data
      final settings = AppSettings(
        notifications: NotificationSettings(
          pushNotifications: true,
          emailNotifications: true,
          smsNotifications: false,
          orderUpdates: true,
          promotionalOffers: false,
          newRestaurants: true,
        ),
        privacy: PrivacySettings(
          shareLocation: true,
          shareOrderHistory: false,
          allowAnalytics: true,
        ),
        app: AppPreferences(
          language: 'en',
          currency: 'USD',
          theme: 'system',
          autoLocation: true,
          vegMode: false,
        ),
      );

      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(
          notifications: NotificationSettings(
            pushNotifications: event.pushNotifications,
            emailNotifications: event.emailNotifications,
            smsNotifications: event.smsNotifications,
            orderUpdates: event.orderUpdates,
            promotionalOffers: event.promotionalOffers,
            newRestaurants: event.newRestaurants,
          ),
        );

        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to update notification settings: $e'));
    }
  }

  Future<void> _onUpdatePrivacySettings(
    UpdatePrivacySettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(
          privacy: PrivacySettings(
            shareLocation: event.shareLocation,
            shareOrderHistory: event.shareOrderHistory,
            allowAnalytics: event.allowAnalytics,
          ),
        );

        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to update privacy settings: $e'));
    }
  }

  Future<void> _onUpdateAppSettings(
    UpdateAppSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(
          app: AppPreferences(
            language: event.language,
            currency: event.currency,
            theme: event.theme,
            autoLocation: event.autoLocation,
            vegMode: currentState.settings.app.vegMode,
          ),
        );

        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to update app settings: $e'));
    }
  }

  Future<void> _onToggleVegMode(
    ToggleVegMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(
          app: currentState.settings.app.copyWith(
            vegMode: !currentState.settings.app.vegMode,
          ),
        );

        emit(currentState.copyWith(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to toggle veg mode: $e'));
    }
  }

  Future<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate cache clearing
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // In real app, this would clear app cache
      emit(SettingsLoaded(settings: state is SettingsLoaded 
          ? (state as SettingsLoaded).settings 
          : AppSettings.defaultSettings()));
    } catch (e) {
      emit(SettingsError('Failed to clear cache: $e'));
    }
  }

  Future<void> _onExportData(
    ExportData event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate data export
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // In real app, this would export user data
      emit(SettingsLoaded(settings: state is SettingsLoaded 
          ? (state as SettingsLoaded).settings 
          : AppSettings.defaultSettings()));
    } catch (e) {
      emit(SettingsError('Failed to export data: $e'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate account deletion
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // In real app, this would delete the user account
      emit(SettingsLoaded(settings: AppSettings.defaultSettings()));
    } catch (e) {
      emit(SettingsError('Failed to delete account: $e'));
    }
  }
}

// Settings models
class AppSettings {
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final AppPreferences app;

  const AppSettings({
    required this.notifications,
    required this.privacy,
    required this.app,
  });

  AppSettings copyWith({
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    AppPreferences? app,
  }) {
    return AppSettings(
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      app: app ?? this.app,
    );
  }

  static AppSettings defaultSettings() {
    return const AppSettings(
      notifications: NotificationSettings(),
      privacy: PrivacySettings(),
      app: AppPreferences(),
    );
  }
}

class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool promotionalOffers;
  final bool newRestaurants;

  const NotificationSettings({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.orderUpdates = true,
    this.promotionalOffers = false,
    this.newRestaurants = true,
  });
}

class PrivacySettings {
  final bool shareLocation;
  final bool shareOrderHistory;
  final bool allowAnalytics;

  const PrivacySettings({
    this.shareLocation = true,
    this.shareOrderHistory = false,
    this.allowAnalytics = true,
  });
}

class AppPreferences {
  final String language;
  final String currency;
  final String theme;
  final bool autoLocation;
  final bool vegMode;

  const AppPreferences({
    this.language = 'en',
    this.currency = 'USD',
    this.theme = 'system',
    this.autoLocation = true,
    this.vegMode = false,
  });

  AppPreferences copyWith({
    String? language,
    String? currency,
    String? theme,
    bool? autoLocation,
    bool? vegMode,
  }) {
    return AppPreferences(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      theme: theme ?? this.theme,
      autoLocation: autoLocation ?? this.autoLocation,
      vegMode: vegMode ?? this.vegMode,
    );
  }
} 