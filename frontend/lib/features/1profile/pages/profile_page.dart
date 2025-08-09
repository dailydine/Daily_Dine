import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../bloc/profile_bloc.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/loading_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const LoadingWidget();
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(const LoadProfile());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded) {
              return _buildProfileContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return Column(
      children: [
        // Header with back and home buttons
        _buildHeader(context),
        
        // User profile section
        _buildUserProfile(context, state.user),
        
        // Menu items
        Expanded(
          child: SingleChildScrollView(
            child: _buildMenuItems(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (disabled since this is the initial route)
          IconButton(
            onPressed: null, // Disabled since this is the initial route
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
              size: 24,
            ),
          ),
          
          // Home button
          IconButton(
            onPressed: () {
              // TODO: Navigate to home when implemented
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home - Coming Soon')),
              );
            },
            icon: const Icon(
              Icons.home,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Avatar with edit button
          Stack(
            children: [
              // Avatar circle
              GestureDetector(
                onTap: () {
                  context.go('/edit-profile');
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD84315), // Burnt orange color (consistent with edit profile)
                    shape: BoxShape.circle,
                    image: user.avatar != null
                        ? DecorationImage(
                            image: FileImage(File(user.avatar!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user.avatar == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        )
                      : null,
                ),
              ),
              
              // Edit button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    context.go('/edit-profile');
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // User name
          Text(
            user.fullDisplayName.isNotEmpty 
                ? user.fullDisplayName 
                : user.displayName.isNotEmpty 
                    ? user.displayName 
                    : 'Add Your Name',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // User email
          Text(
            user.email.isNotEmpty ? user.email : 'Add Your Email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              context.go('/edit-profile');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Wallet',
            onTap: () {
              context.go('/wallet');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildVegModeItem(context, state.isVegMode),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.favorite_outline,
            title: 'Favorites',
            onTap: () {
              context.go('/favorites');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.local_offer_outlined,
            title: 'My coupons',
            onTap: () {
              context.go('/my-coupons');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.history,
            title: 'My orders',
            onTap: () {
              context.go('/my-orders');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              context.go('/settings');
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Log out',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minVerticalPadding: 0,
        leading: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 14,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildVegModeItem(BuildContext context, bool isVegMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minVerticalPadding: 0,
        leading: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50), // Green color for veg mode
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.circle,
            color: Colors.white,
            size: 6,
          ),
        ),
        title: Text(
          'Veg Mode',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: isVegMode,
          onChanged: (value) {
            context.read<ProfileBloc>().add(const ToggleVegMode());
          },
          activeColor: const Color(0xFF4CAF50),
          inactiveThumbColor: Colors.grey[400],
          inactiveTrackColor: Colors.grey[300],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Log out?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                // Separator line
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<ProfileBloc>().add(const Logout());
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Separator line
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
