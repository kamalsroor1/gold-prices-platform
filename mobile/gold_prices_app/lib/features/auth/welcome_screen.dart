import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../navigation/main_navigation_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'متابعة الأسعار لحظياً',
      'description': 'احصل على أسعار الذهب والأعيرة المختلفة محدثة مباشرة من البورصة العالمية والمحلية بدقة فائقة.',
      'icon': 'show_chart',
    },
    {
      'title': 'أدوات حساب ذكية',
      'description': 'حاسبة مالية متقدمة لتقدير قيمة الذهب وحساب المصنعية والضرائب وسعر إعادة الشراء بلمسة واحدة.',
      'icon': 'calculate',
    },
    {
      'title': 'إشعارات حية وتنبيهات',
      'description': 'اضبط تنبيهاتك الخاصة لتصلك إشعارات فورية عند صعود أو هبوط الأسعار عن المستويات التي تختارها.',
      'icon': 'notifications_active',
    },
  ];

  IconData _getIcon(String name) {
    switch (name) {
      case 'show_chart':
        return Icons.show_chart;
      case 'calculate':
        return Icons.calculate;
      case 'notifications_active':
        return Icons.notifications_active;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // زر التخطي للمتابعة كزائر في الأعلى
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                    );
                  },
                  child: const Text(
                    'تخطي',
                    style: TextStyle(color: Color(0xFF00BFA5), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final slide = _onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA5).withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(slide['icon']!),
                            size: 80,
                            color: const Color(0xFF00BFA5),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              // مؤشرات الصفحات
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? const Color(0xFF00BFA5) : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // أزرار التحكم والولوج
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00BFA5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(color: Color(0xFF00BFA5), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
