import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/user_profile.dart';
import '../models/auth_service.dart';
import 'profile_edit_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = UserProfileService();

    return ValueListenableBuilder<UserProfile>(
      valueListenable: profileService.profileNotifier,
      builder: (context, profile, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          appBar: AppBar(
            title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF111827),
            elevation: 0,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Profile Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(profile.profileImageUrl),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(profile.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        if (AuthService().userName == 'Admin')
                          IconButton(
                            icon: const Icon(LucideIcons.edit3, color: Color(0xFF2C3545), size: 20),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileEditScreen(currentProfile: profile)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                
                // Settings Options
                if (AuthService().userName == 'Admin')
                  _buildSettingsGroup(context, 'Account Settings', [
                    _buildSettingsTile(
                      context,
                      'Edit Profile',
                      LucideIcons.user,
                      const Color(0xFF2C3545),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileEditScreen(currentProfile: profile)),
                      ),
                    ),
                  ]),

                if (AuthService().userName != 'Admin')
                  _buildSettingsGroup(context, 'Session Information', [
                    _buildSettingsTile(
                      context,
                      'Current Branch',
                      LucideIcons.mapPin,
                      const Color(0xFF3B82F6),
                      () {},
                      trailing: Text(AuthService().branch, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    _buildSettingsTile(
                      context,
                      'User Role',
                      LucideIcons.shield,
                      const Color(0xFF8B5CF6),
                      () {},
                      trailing: Text(AuthService().userPost, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ),
                  ]),

                const SizedBox(height: 24),

                _buildSettingsGroup(context, 'Support & Help', [
                  _buildSettingsTile(
                    context,
                    'Contact Help',
                    LucideIcons.helpCircle,
                    const Color(0xFF10B981),
                    () => _showHelpDialog(context),
                  ),
                  _buildSettingsTile(
                    context,
                    'Terms of Service',
                    LucideIcons.fileText,
                    Colors.grey,
                    () {},
                  ),
                ]),

                const SizedBox(height: 32),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(LucideIcons.logOut, size: 20),
                      label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        backgroundColor: const Color(0xFFFee2e2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(title.toUpperCase(), 
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.2)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: trailing ?? const Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Contact Support', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('For assistance, please contact our support line at:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.phone, color: Color(0xFF2C3545), size: 20),
                  SizedBox(width: 12),
                  Text('0777271735', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF111827))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Real-world: launch('tel:0777271735');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3545),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Navigate to Login and clear stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}

