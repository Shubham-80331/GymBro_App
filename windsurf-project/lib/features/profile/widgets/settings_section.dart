import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../screens/edit_profile_screen.dart';

class SettingsSection extends StatelessWidget {
  final UserModel userModel;

  const SettingsSection({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isGuest = authProvider.user == null;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkGrey),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            'Edit Profile',
            'Update your personal information',
            Icons.person,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),
          
          _buildDivider(),
          
          _buildSettingsTile(
            context,
            'Notifications',
            'Manage workout and nutrition reminders',
            Icons.notifications,
            () {
              // TODO: Navigate to notifications settings
            },
          ),
          
          _buildDivider(),
          
          _buildSettingsTile(
            context,
            'Privacy',
            'Control your data and privacy settings',
            Icons.lock,
            () {
              // TODO: Navigate to privacy settings
            },
          ),
          
          _buildDivider(),
          
          _buildSettingsTile(
            context,
            'About',
            'App version and information',
            Icons.info,
            () {
              _showAboutDialog(context);
            },
          ),
          
          if (!isGuest) ...[
            _buildDivider(),
            _buildSettingsTile(
              context,
              'Sign Out',
              'Sign out of your account',
              Icons.logout,
              () {
                _showSignOutDialog(context);
              },
              isDestructive: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.orange : AppTheme.neonGreen,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppTheme.orange : AppTheme.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.grey,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppTheme.darkGrey,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'About Gym Bro Tracker',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(color: AppTheme.grey),
            ),
            SizedBox(height: 8),
            Text(
              'A comprehensive fitness tracking application for gym enthusiasts.',
              style: TextStyle(color: AppTheme.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Built with Flutter and Firebase',
              style: TextStyle(color: AppTheme.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Sign Out',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppTheme.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text(
              'SIGN OUT',
              style: TextStyle(color: AppTheme.orange),
            ),
          ),
        ],
      ),
    );
  }
}
