import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import '../../core/local_storage_service.dart';
import '../auth/auth_provider.dart';
import '../auth/welcome_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../alerts/alert_screen.dart';
import '../prices/price_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late bool _notificationsEnabled;
  late bool _periodicAlertsEnabled;
  late bool _dailySummaryEnabled;
  late String _appLanguage;
  
  late int _countryId;
  late String _selectedCountry;
  late String _defaultCurrency;

  @override
  void initState() {
    super.initState();
    // تحميل جميع الحالات المحفوظة من الذاكرة المحلية المستمرة عند بدء الشاشة
    _notificationsEnabled = LocalStorageService.priceAlertsEnabled;
    _periodicAlertsEnabled = LocalStorageService.periodicAlertsEnabled;
    _dailySummaryEnabled = LocalStorageService.dailySummaryEnabled;
    _appLanguage = LocalStorageService.appLanguage;
    
    _countryId = LocalStorageService.countryId;
    _selectedCountry = _getCountryName(_countryId);
    _defaultCurrency = _getCurrencyName(_countryId);
    
    // جلب الإعدادات السحابية الحقيقية من السيرفر فور تشغيل الشاشة لمزامنتها!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSettingsFromServer();
    });
  }

  // مزامنة وسحب الإعدادات الفعلية للمستخدم من السيرفر
  Future<void> _syncSettingsFromServer() async {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;
    if (isGuest) return;

    try {
      final apiClient = ref.read(apiClientProvider);
      final dynamic response = await apiClient.get('profile', authenticated: true);
      
      if (response is Map && response.containsKey('user')) {
        final map = Map<String, dynamic>.from(response['user']);
        
        setState(() {
          _countryId = map['country_id'] ?? _countryId;
          _selectedCountry = _getCountryName(_countryId);
          _defaultCurrency = _getCurrencyName(_countryId);
          
          _notificationsEnabled = map['price_alerts_enabled'] ?? _notificationsEnabled;
          _periodicAlertsEnabled = map['periodic_alerts_enabled'] ?? _periodicAlertsEnabled;
          _dailySummaryEnabled = map['daily_summary_enabled'] ?? _dailySummaryEnabled;
          _appLanguage = map['app_language'] ?? _appLanguage;
        });

        // تحديث الذاكرة المحلية المستمرة
        await LocalStorageService.saveCountryId(_countryId);
        ref.read(selectedCountryIdProvider.notifier).state = _countryId;
        await LocalStorageService.savePriceAlerts(_notificationsEnabled);
        await LocalStorageService.savePeriodicAlerts(_periodicAlertsEnabled);
        await LocalStorageService.saveDailySummary(_dailySummaryEnabled);
        await LocalStorageService.saveAppLanguage(_appLanguage);
      }
    } catch (e) {
      print('Error syncing settings from server: $e');
    }
  }

  // حفظ وتحديث الإعدادات سحابياً في قاعدة بيانات السيرفر
  Future<void> _updateSettingsOnServer(Map<String, dynamic> data) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post('profile', data, authenticated: true);
    } catch (e) {
      print('Error syncing profile settings to server: $e');
    }
  }

  // مفسر أسماء الدول بناءً على الـ ID
  String _getCountryName(int id) {
    switch (id) {
      case 1: return 'مصر';
      case 2: return 'السعودية';
      case 3: return 'الإمارات';
      case 4: return 'الكويت';
      default: return 'مصر';
    }
  }

  // مفسر رموز العملات باللغة العربية بناءً على الـ ID
  String _getCurrencyName(int id) {
    switch (id) {
      case 1: return 'جنيه مصري (ج.م)';
      case 2: return 'ريال سعودي (ر.س)';
      case 3: return 'درهم إماراتي (د.إ)';
      case 4: return 'دينار كويتي (د.ك)';
      default: return 'جنيه مصري (ج.م)';
    }
  }

  // فتح نافذة تغيير الدولة المخصصة
  void _showCountrySelectionDialog() {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;
    final countries = [
      {'id': 1, 'name': 'مصر'},
      {'id': 2, 'name': 'السعودية'},
      {'id': 3, 'name': 'الإمارات'},
      {'id': 4, 'name': 'الكويت'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر الدولة الحالية لتحديث الأسعار',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...countries.map((country) {
                final int id = country['id'] as int;
                final isSelected = _countryId == id;
                return ListTile(
                  title: Text(country['name'] as String, style: TextStyle(color: isSelected ? const Color(0xFF00BFA5) : Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF00BFA5)) : null,
                  onTap: () {
                    setState(() {
                      _countryId = id;
                      _selectedCountry = country['name'] as String;
                      _defaultCurrency = _getCurrencyName(id);
                    });
                    
                    // 1. حفظ التغيير محلياً في Hive
                    LocalStorageService.saveCountryId(id);
                    
                    // 2. تحديث الـ Provider المركزي لتغيير وتحديث أسعار كل الشاشات لحظياً!
                    ref.read(selectedCountryIdProvider.notifier).state = id;
                    
                    // 3. حفظ التغيير سحابياً إن لم يكن زائرًا
                    if (!isGuest) {
                      _updateSettingsOnServer({'country_id': id});
                    }

                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم تحويل الدولة بنجاح وتحديث أسعار سوق ${country['name']}!'),
                        backgroundColor: const Color(0xFF00BFA5),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // فتح نافذة تغيير اللغة
  void _showLanguageSelectionDialog() {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر لغة التطبيق المفضلة',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...['العربية', 'English'].map((lang) {
                final isSelected = _appLanguage == lang;
                return ListTile(
                  title: Text(lang, style: TextStyle(color: isSelected ? const Color(0xFF00BFA5) : Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF00BFA5)) : null,
                  onTap: () {
                    setState(() {
                      _appLanguage = lang;
                    });
                    LocalStorageService.saveAppLanguage(lang);
                    
                    if (!isGuest) {
                      _updateSettingsOnServer({'app_language': lang});
                    }

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

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
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;

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
            onTap: _showCountrySelectionDialog,
          ),
          const Divider(height: 1, color: Colors.white10),
          
          // العملة الافتراضية
          _buildSettingsTile(
            icon: Icons.monetization_on_outlined,
            title: 'العملة الافتراضية',
            trailing: Text(
              _defaultCurrency,
              style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('العملة الافتراضية تتبع الدولة المحددة تلقائياً.')),
              );
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
              onChanged: (value) async {
                setState(() {
                  _notificationsEnabled = value;
                });
                await LocalStorageService.savePriceAlerts(value);
                if (!isGuest) {
                  _updateSettingsOnServer({'price_alerts_enabled': value});
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertsScreen()),
              );
            },
          ),
          const Divider(height: 1, color: Colors.white10),

          // تنبيهات التغير الدوري (كل بضع ساعات)
          _buildSettingsTile(
            icon: Icons.update,
            title: 'تنبيهات التغير الدوري (كل بضع ساعات)',
            trailing: Switch.adaptive(
              value: _periodicAlertsEnabled,
              activeColor: const Color(0xFF00BFA5),
              onChanged: (value) async {
                setState(() {
                  _periodicAlertsEnabled = value;
                });
                await LocalStorageService.savePeriodicAlerts(value);
                if (!isGuest) {
                  _updateSettingsOnServer({'periodic_alerts_enabled': value});
                }
              },
            ),
            onTap: () {},
          ),
          const Divider(height: 1, color: Colors.white10),

          // تقرير التغير اليومي (ملخص الصباح والمساء)
          _buildSettingsTile(
            icon: Icons.summarize_outlined,
            title: 'تقرير التغير اليومي (ملخص الصباح والمساء)',
            trailing: Switch.adaptive(
              value: _dailySummaryEnabled,
              activeColor: const Color(0xFF00BFA5),
              onChanged: (value) async {
                setState(() {
                  _dailySummaryEnabled = value;
                });
                await LocalStorageService.saveDailySummary(value);
                if (!isGuest) {
                  _updateSettingsOnServer({'daily_summary_enabled': value});
                }
              },
            ),
            onTap: () {},
          ),
          const Divider(height: 1, color: Colors.white10),
          
          // اللغة
          _buildSettingsTile(
            icon: Icons.language,
            title: 'لغة التطبيق',
            trailing: Text(
              _appLanguage,
              style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
            ),
            onTap: _showLanguageSelectionDialog,
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
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
