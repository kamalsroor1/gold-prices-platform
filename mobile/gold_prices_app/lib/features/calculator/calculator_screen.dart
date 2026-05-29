import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../prices/price_provider.dart';
import 'calculator_service.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // حقول المدخلات
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _makingChargeController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _cashbackController = TextEditingController();

  double _calculatedResult = 0.0;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _calculatedResult = 0.0;
        _hasCalculated = false;
        _clearFields();
      });
    });
  }

  void _clearFields() {
    _weightController.clear();
    _makingChargeController.clear();
    _taxController.clear();
    _cashbackController.clear();
  }

  void _calculate(double goldPrice24k) {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double makingCharge = double.tryParse(_makingChargeController.text) ?? 0.0;

    if (_tabController.index == 0) {
      final double tax = double.tryParse(_taxController.text) ?? 0.0;
      setState(() {
        _calculatedResult = CalculatorService.calculateSellingPrice(
          weight: weight,
          goldPrice24k: goldPrice24k,
          makingCharge: makingCharge,
          tax: tax,
        );
        _hasCalculated = true;
      });
    } else {
      final double cashback = double.tryParse(_cashbackController.text) ?? 0.0;
      setState(() {
        _calculatedResult = CalculatorService.calculateBuybackPrice(
          weight: weight,
          goldPrice24k: goldPrice24k,
          makingCharge: makingCharge,
          cashback: cashback,
        );
        _hasCalculated = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _makingChargeController.dispose();
    _taxController.dispose();
    _cashbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // جلب سعر الذهب 24k تلقائياً من الـ Provider لبلد رقم 1
    final pricesAsync = ref.watch(priceProvider(1));
    double goldPrice24k = 3500.50; // القيمة الافتراضية في حال لم تتوفر البيانات بعد

    pricesAsync.whenData((prices) {
      final price24 = prices.firstWhere(
        (p) => p.karat == '24',
        orElse: () => prices.isNotEmpty ? prices.first : prices.first,
      );
      goldPrice24k = price24.price;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('الحاسبة الذكية'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00BFA5),
          labelColor: const Color(0xFF00BFA5),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'حساب سعر الشراء'),
            Tab(text: 'حساب سعر إعادة الشراء'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // بطاقة سعر الذهب الحالي كمرجع
            Card(
              color: const Color(0xFF161616),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'سعر الذهب المعتمد (عيار 24)',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    pricesAsync.maybeWhen(
                      data: (prices) {
                        return Text(
                          '\$${goldPrice24k.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        );
                      },
                      orElse: () => const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Color(0xFF00BFA5), strokeWidth: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // حقول الإدخال
            _buildInputField(controller: _weightController, label: 'وزن السبيكة (جرام)', icon: Icons.scale),
            const SizedBox(height: 16),
            _buildInputField(controller: _makingChargeController, label: 'المصنعية للجرام الواحد', icon: Icons.monetization_on),
            const SizedBox(height: 16),
            
            if (_tabController.index == 0) ...[
              _buildInputField(controller: _taxController, label: 'الضرائب والرسوم الإجمالية', icon: Icons.gavel),
            ] else ...[
              _buildInputField(controller: _cashbackController, label: 'الكاش باك (Cashback) للجرام', icon: Icons.replay),
            ],
            
            const SizedBox(height: 24),
            
            // زر الحساب
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => _calculate(goldPrice24k),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                child: const Text(
                  'احسب الآن',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // بطاقة عرض النتيجة
            if (_hasCalculated) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF00BFA5)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            _tabController.index == 0 ? 'سعر الشراء النهائي التقديري' : 'سعر إعادة الشراء الصافي التقديري',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_calculatedResult.toStringAsFixed(2)}',
            style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
