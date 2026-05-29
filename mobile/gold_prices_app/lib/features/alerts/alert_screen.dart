import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import '../../core/local_storage_service.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'alert_provider.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  final _targetPriceController = TextEditingController();
  int _selectedKarat = 24;

  @override
  void dispose() {
    _targetPriceController.dispose();
    super.dispose();
  }

  // فتح نافذة إنشاء تنبيه جديد
  void _showAddAlertBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'إنشاء تنبيه سعري جديد',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // اختيار العيار
                  const Text('اختر عيار الذهب المستهدف:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [24, 21, 18].map((karat) {
                      final isSelected = _selectedKarat == karat;
                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            setModalState(() {
                              _selectedKarat = karat;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF00BFA5) : const Color(0xFF090909),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? const Color(0xFF00BFA5) : Colors.grey.shade900),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'عيار $karat',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  // السعر المستهدف
                  TextField(
                    controller: _targetPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'السعر المستهدف بالعملة المحلية',
                      prefixIcon: Icon(Icons.notifications_active, color: Color(0xFF00BFA5)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final double targetPrice = double.tryParse(_targetPriceController.text) ?? 0.0;
                        if (targetPrice > 0) {
                          ref.read(alertProvider.notifier).addAlert(1, _selectedKarat, targetPrice);
                          _targetPriceController.clear();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم ضبط التنبيه السعري بنجاح!'),
                              backgroundColor: Color(0xFF00BFA5),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('حفظ التنبيه', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isGuest = LocalStorageService.token == null || LocalStorageService.token!.isEmpty;
    final alertsAsync = isGuest ? null : ref.watch(alertProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        title: const Text('تنبيهات الأسعار الذكية'),
      ),
      body: isGuest 
          ? _buildGuestOnboarding() 
          : alertsAsync!.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00BFA5))),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('حدث خطأ: $err', style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
              data: (alerts) {
                if (alerts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_none_outlined, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('لا توجد تنبيهات أسعار نشطة حالياً', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _showAddAlertBottomSheet(context),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('اضبط تنبيهك الأول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA5).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_active, color: Color(0xFF00BFA5)),
                        ),
                        title: Text(
                          'تنبيه ذهب عيار ${alert.karat}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'عند وصول السعر لـ: ${formatPrice(alert.targetPrice)} ج.م',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            ref.read(alertProvider.notifier).removeAlert(alert.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حذف التنبيه السعري بنجاح')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: isGuest 
          ? null 
          : FloatingActionButton(
              onPressed: () => _showAddAlertBottomSheet(context),
              backgroundColor: const Color(0xFF00BFA5),
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  // واجهة زائر لحثه على تسجيل الدخول للاشتراك بالتنبيهات
  Widget _buildGuestOnboarding() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade900),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_paused_outlined, size: 80, color: Color(0xFF00BFA5)),
              const SizedBox(height: 24),
              const Text(
                'تنبيهات الأسعار المخصصة',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'ميزة التنبيهات مخصصة للأعضاء فقط، يرجى تسجيل الدخول أو إنشاء حساب لتصلك إشعارات فورية عند صعود أو هبوط أسعار الذهب عن المستويات المستهدفة.',
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BFA5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00BFA5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('إنشاء حساب', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
