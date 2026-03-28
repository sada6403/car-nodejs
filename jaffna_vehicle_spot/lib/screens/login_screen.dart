import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'main_layout.dart';
import '../models/auth_service.dart';
import '../models/attendance_service.dart';

// Brand Colors derived from the logo
const Color kBrandDark = Color(0xFF2C3545); // Deep Slate / Charcoal
const Color kBrandGold = Color(0xFFE8BC44); // Warm Gold / Yellow
const Color kBrandLight = Color(0xFFF8FAFC); // Very Light Slate
const Color kTextDark = Color(0xFF1E293B);
const Color kTextMuted = Color(0xFF64748B);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'Admin';
  String _selectedBranch = 'Jaffna';

  // Role credentials
  final Map<String, Map<String, String>> _roleCredentials = {
    'Admin':   {'username': 'admin',   'password': 'admin123',   'title': 'System Administrator'},
    'Manager-Jaffna': {'username': 'manager_jaffna', 'password': 'manager123', 'title': 'Fleet Manager'},
    'Manager-Poonakari': {'username': 'manager_poonakari', 'password': 'manager123', 'title': 'Fleet Manager'},
    'Staff-Jaffna':   {'username': 'staff_jaffna',   'password': 'staff123',   'title': 'Staff Member'},
    'Staff-Poonakari':   {'username': 'staff_poonakari',   'password': 'staff123',   'title': 'Staff Member'},
  };

  final Map<String, IconData> _roleIcons = {
    'Admin':   LucideIcons.shieldCheck,
    'Manager': LucideIcons.briefcase,
    'Staff':   LucideIcons.user,
  };

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final roleKey = _selectedRole == 'Admin' ? 'Admin' : '$_selectedRole-$_selectedBranch';
    final creds = _roleCredentials[roleKey]!;
    final userBranch = _selectedRole == 'Admin' ? 'All Branches' : _selectedBranch;

    if (username == creds['username'] && password == creds['password']) {
      setState(() => _isLoading = true);
      
      // Mark attendance (Only for non-Admin roles)
      if (_selectedRole != 'Admin') {
        await AttendanceService().checkIn(
          creds['username']!,
          '$_selectedRole-$_selectedBranch', // Name for reporting
          creds['title']!, // Role
          userBranch,
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));
      AuthService().setUser(_selectedRole, creds['title']!, userBranch, userId: creds['username']!);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid credentials for $_selectedRole. Check username/password.',
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kBrandDark.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(LucideIcons.car, size: 40, color: kBrandDark),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your role to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: kTextMuted),
              ),
              const SizedBox(height: 36),

              // Role Selector (Premium Design)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kBrandLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBrandDark.withValues(alpha: 0.05)),
                ),
                child: Row(
                  children: ['Admin', 'Manager', 'Staff'].map((role) {
                    final isSelected = _selectedRole == role;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRole = role;
                            _usernameController.clear();
                            _passwordController.clear();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? kBrandDark : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: kBrandDark.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _roleIcons[role],
                                size: 22,
                                color: isSelected ? kBrandGold : kTextMuted,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                role,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? Colors.white : kTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              if (_selectedRole != 'Admin') ...[
                const SizedBox(height: 24),
                const Text(
                  'Select Branch',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextDark),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: kBrandLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBrandDark.withValues(alpha: 0.05), width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBranch,
                      isExpanded: true,
                      icon: const Icon(LucideIcons.chevronDown, color: kTextMuted),
                      items: ['Jaffna', 'Poonakari'].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: kTextDark),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedBranch = val;
                            _usernameController.clear();
                            _passwordController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Username Field
              _buildTextField(
                label: 'Username',
                controller: _usernameController,
                icon: LucideIcons.user,
              ),
              const SizedBox(height: 20),

              // Password Field
              _buildTextField(
                label: 'Password',
                controller: _passwordController,
                icon: LucideIcons.lock,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: kBrandDark,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrandGold,
                    foregroundColor: kBrandDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: kBrandDark, strokeWidth: 3),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_roleIcons[_selectedRole], size: 20, color: kBrandDark),
                            const SizedBox(width: 10),
                            Text(
                              'Sign In as $_selectedRole',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 28),
              
              // Credentials hint showing dynamically
              Builder(
                builder: (context) {
                  final currentKey = _selectedRole == 'Admin' ? 'Admin' : '$_selectedRole-$_selectedBranch';
                  final currentCreds = _roleCredentials[currentKey]!;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kBrandDark.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kBrandDark.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.info, size: 18, color: kTextMuted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Hint: ${currentCreds['username']} / ${currentCreds['password']}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: kTextMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kTextDark,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500, color: kTextDark),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: kTextMuted),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                      size: 20,
                      color: kTextMuted,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: kBrandLight,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kBrandDark.withValues(alpha: 0.05), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kBrandDark, width: 2),
            ),
            hintText: 'Enter your $label',
            hintStyle: const TextStyle(color: kTextMuted, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

