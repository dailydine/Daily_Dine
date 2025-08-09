import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/user_model.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class ToggleVegMode extends ProfileEvent {
  const ToggleVegMode();
}

class Logout extends ProfileEvent {
  const Logout();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String? avatarPath;

  const UpdateProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [name, email, phoneNumber, dateOfBirth, gender, avatarPath];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final bool isVegMode;

  const ProfileLoaded({
    required this.user,
    required this.isVegMode,
  });

  @override
  List<Object?> get props => [user, isVegMode];

  ProfileLoaded copyWith({
    UserModel? user,
    bool? isVegMode,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isVegMode: isVegMode ?? this.isVegMode,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<ToggleVegMode>(_onToggleVegMode);
    on<UpdateProfile>(_onUpdateProfile);
    on<Logout>(_onLogout);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock user data for now (empty initially)
      final user = UserModel(
        id: '1',
        email: '', // Empty initially
        firstName: '', // Empty initially
        lastName: '', // Empty initially
        phoneNumber: '', // Empty initially
        avatar: null,
        address: null,
        city: null,
        state: null,
        zipCode: null,
        country: null,
        dateOfBirth: null, // Empty initially
        gender: '', // Empty initially
        isEmailVerified: false,
        isPhoneVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        walletBalance: 0.0,
        totalOrders: 0,
        totalBookings: 0,
        favoriteRestaurants: [],
        favoriteMenuItems: [],
      );

      emit(ProfileLoaded(user: user, isVegMode: false));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onToggleVegMode(ToggleVegMode event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isVegMode: !currentState.isVegMode));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      
      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Parse date from DD/MM/YYYY format
        DateTime? parsedDate;
        if (event.dateOfBirth.isNotEmpty) {
          final parts = event.dateOfBirth.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (day != null && month != null && year != null) {
              parsedDate = DateTime(year, month, day);
            }
          }
        }
        
        // Split name into first and last name
        final nameParts = event.name.trim().split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        // Update user data
        final updatedUser = currentState.user.copyWith(
          firstName: firstName,
          lastName: lastName,
          email: event.email,
          phoneNumber: event.phoneNumber,
          dateOfBirth: parsedDate,
          gender: event.gender,
          avatar: event.avatarPath,
        );
        
        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  void _onLogout(Logout event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    try {
      // TODO: Implement logout logic
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
