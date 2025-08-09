import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildSettingsContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          ),
          Text(
            'SETTINGS',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home - Coming Soon')),
              );
            },
            icon: const Icon(Icons.home, color: Colors.black, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Edit Profile Option
          _buildSettingsItem(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              context.go('/edit-profile');
            },
            showArrow: true,
          ),
          
          const SizedBox(height: 16),
          
          // Notifications Setting
          _buildNotificationSetting(context),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        leading: Icon(icon, color: Colors.black, size: 24),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: showArrow
            ? const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotificationSetting(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        leading: const Icon(Icons.notifications_outlined, color: Colors.black, size: 24),
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled',
                ),
                backgroundColor: _notificationsEnabled ? Colors.green : Colors.grey,
              ),
            );
          },
          activeColor: AppTheme.primaryColor,
        ),
      ),
    );
  }
} 