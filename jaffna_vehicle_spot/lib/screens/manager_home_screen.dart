import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/auth_service.dart';
import '../models/vehicle.dart';
import '../models/staff.dart';
import 'manager_settings_screen.dart';
import 'customers_screen.dart';
import 'staff_screen.dart';
import 'reports_screen.dart';
import 'login_screen.dart';
import 'garage_vehicles_screen.dart';
import 'commission_reports_screen.dart';

const Color kBrandDark = Color(0xFF2C3545);
const Color kBrandGold = Color(0xFFE8BC44);

class ManagerHomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;
  const ManagerHomeScreen({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // 1. Sleek Modern Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 36,
              ),
              decoration: const BoxDecoration(
                color: kBrandDark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jaffna Vehicle Spot • ${AuthService().branch}',
                    style: const TextStyle(
                      color: kBrandGold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/logo.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(LucideIcons.image, color: kBrandDark, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Branch Management,',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              AuthService().userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kBrandGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kBrandGold.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.shieldCheck, color: kBrandGold, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              AuthService().userPost.split(' ').first,
                              style: const TextStyle(
                                color: kBrandGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 3-Line Menu
                      PopupMenuButton<String>(
                        icon: const Icon(LucideIcons.menu, color: Colors.white, size: 28),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        offset: const Offset(0, 45),
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'settings') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ManagerSettingsScreen()),
                            );
                          } else if (value == 'customers') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CustomersScreen()),
                            );
                          } else if (value == 'staff') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StaffScreen()),
                            );
                          } else if (value == 'reports') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportsScreen()),
                            );
                          } else if (value == 'garage') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GarageVehiclesScreen()),
                            );
                          } else if (value == 'commissions') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CommissionReportsScreen()),
                            );
                          } else if (value == 'logout') {
                            AuthService().logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'settings',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.settings, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'customers',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.users, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Customers', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'staff',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.userCheck, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Staffs', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'reports',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.barChart3, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Reports', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'garage',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.warehouse, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Vehicles in Garage', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'commissions',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.percent, color: kBrandDark, size: 20),
                                const SizedBox(width: 12),
                                const Text('Commission Reports', style: TextStyle(fontWeight: FontWeight.w600, color: kBrandDark)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(LucideIcons.logOut, color: Colors.white70, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          AuthService().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 2. Branch Quick Management Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Branch Quick Operations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAction(
                        icon: LucideIcons.layers,
                        label: 'Stock List',
                        color: kBrandDark,
                        onTap: () => onTabChange?.call(1),
                      ),
                      _buildQuickAction(
                        icon: LucideIcons.receipt,
                        label: 'All Bills',
                        color: const Color(0xFF0EA5E9),
                        onTap: () => onTabChange?.call(2),
                      ),
                      _buildQuickAction(
                        icon: LucideIcons.users,
                        label: 'My Staff',
                        color: kBrandGold,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffScreen())),
                      ),
                      _buildQuickAction(
                        icon: LucideIcons.barChart3,
                        label: 'Reports',
                        color: const Color(0xFF10B981),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),


          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Branch Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 130,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCompactMetric(
                        icon: LucideIcons.target,
                        color: const Color(0xFFF59E0B),
                        label: 'Target Goal',
                        value: 'Rs. 25M',
                        trend: 'Monthly',
                      ),
                      ValueListenableBuilder<List<Staff>>(
                        valueListenable: StaffService().staffsNotifier,
                        builder: (context, staffs, _) => _buildCompactMetric(
                          icon: LucideIcons.users,
                          color: const Color(0xFF6366F1),
                          label: 'Team Size',
                          value: '${staffs.length}',
                          trend: 'Active',
                        ),
                      ),
                      ValueListenableBuilder<List<Vehicle>>(
                        valueListenable: VehicleService().vehiclesNotifier,
                        builder: (context, vehicles, _) => _buildCompactMetric(
                          icon: LucideIcons.package,
                          color: kBrandDark,
                          label: 'Branch Stock',
                          value: '${vehicles.length}',
                          trend: 'Items',
                        ),
                      ),
                      _buildCompactMetric(
                        icon: LucideIcons.userPlus,
                        color: const Color(0xFF10B981),
                        label: 'Recent Users',
                        value: '28',
                        trend: '+4 MTD',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 4. Branch Recent Activity
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Branch Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onTabChange?.call(3),
                    style: TextButton.styleFrom(
                      foregroundColor: kBrandGold,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View Reports', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildActivityItem(
                  icon: LucideIcons.filePlus,
                  title: 'New Vehicle Added',
                  subtitle: 'Toyota Land Cruiser 2024 by Admin',
                  timeAgo: '15 mins ago',
                  color: const Color(0xFF8B5CF6),
                ),
                _buildActivityItem(
                  icon: LucideIcons.userPlus,
                  title: 'New Customer Registered',
                  subtitle: 'Arun Kumar from Jaffna Branch',
                  timeAgo: '1 hour ago',
                  color: const Color(0xFF10B981),
                ),
                _buildActivityItem(
                  icon: LucideIcons.receipt,
                  title: 'Sale Completed',
                  subtitle: 'BMW 5 Series sold for Rs. 22M',
                  timeAgo: '3 hours ago',
                  color: const Color(0xFF0EA5E9),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMetric({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String trend,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: trend.contains('+') || trend == 'Active' || trend == 'Now'
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: trend.contains('+') || trend == 'Active' || trend == 'Now'
                        ? const Color(0xFF059669) 
                        : color,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String timeAgo,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
