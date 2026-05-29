import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import '../../core/local_storage_service.dart';
import '../auth/auth_provider.dart';
import '../auth/welcome_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  String _defaultCurrency = 'USD (\$)';
  String _selectedCountry = 'مصر';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        title: const Text('الملف الشخصي والإعدادات'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Header Info
            _buildProfileHeader(),
            const SizedBox(height: 28),
            
            // 2. Platform Settings
            const Text(
              'تخصيص المنصة والإعدادات',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(),
            const SizedBox(height: 24),
            
            // 3. User Data / Actions
            _buildActionsCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFF00BFA5).withOpacity(0.1),
                child: const Icon(Icons.person, size: 40, color: Color(0xFF00BFA5)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGuest ? 'المستخدم الزائر' : 'حساب مستخدم نشط',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isGuest ? 'سجل دخول لتفعيل كافة الميزات والتنبيهات المخصصة' : 'مستكشف ومستثمر في سوق الذهب',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'تاريخ الانضمام: مايو 2026',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isGuest) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00BFA5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('إنشاء حساب', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          // الدولة
          _buildSettingsTile(
            icon: Icons.public,
            title: 'الدولة الحالية',
            trailing: Text(
              _selectedCountry,
              style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // تعديل الدولة
            },
          ),
          const Divider(height: 1, color: Colors.white10),
          
          // العملة الافتراضية
          _buildSettingsTile(
            icon: Icons.monetization_on_outlined,
            title: 'العملة الافتراضية',
            trailing: Text(
              _defaultCurrency,
              style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // تعديل العملة
            },
          ),
          const Divider(height: 1, color: Colors.white10),
          
          // الإشعارات والتنبيهات
          _buildSettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'إشعارات تغيرات الأسعار',
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeColor: const Color(0xFF00BFA5),
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            onTap: () {},
          ),
          const Divider(height: 1, color: Colors.white10),
          
          // اللغة
          _buildSettingsTile(
            icon: Icons.language,
            title: 'لغة التطبيق',
            trailing: const Text(
              'العربية',
              style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'عن المنصة ومصادر الأسعار',
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'سياسة الخصوصية والشروط',
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1, color: Colors.white10),
          isGuest
              ? _buildSettingsTile(
                  icon: Icons.login,
                  title: 'تسجيل الدخول',
                  textColor: const Color(0xFF00BFA5),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00BFA5), size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                )
              : _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  textColor: Colors.redAccent,
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.redAccent, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF161616),
                        title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
                        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟', style: TextStyle(color: Colors.grey)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await ref.read(authRepositoryProvider).logout();
                                ref.read(apiClientProvider).clearToken(); // مسح التوكين برمجياً ومحلياً من الذاكرة المستمرة
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                  (route) => false,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('خطأ أثناء تسجيل الخروج: ${e.toString()}')),
                                );
                              }
                            },
                            child: const Text('تأكيد', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? const Color(0xFF00BFA5)),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

