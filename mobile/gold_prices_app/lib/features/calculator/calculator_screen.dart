import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  double _baseGoldValue = 0.0;
  double _makingChargeValue = 0.0;
  double _taxOrCashbackValue = 0.0;
  double _calculatedResult = 0.0;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // إضافة مستمعين للقيام بحسابات فورية ومباشرة أثناء الكتابة
    _weightController.addListener(_onInputChanged);
    _makingChargeController.addListener(_onInputChanged);
    _taxController.addListener(_onInputChanged);
    _cashbackController.addListener(_onInputChanged);

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

  void _onInputChanged() {
    final pricesAsync = ref.read(priceProvider(1));
    double goldPrice24k = 3500.50;

    pricesAsync.whenData((prices) {
      final price24 = prices.firstWhere(
        (p) => p.karat == '24',
        orElse: () => prices.isNotEmpty ? prices.first : prices.first,
      );
      goldPrice24k = price24.price;
    });

    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double makingCharge = double.tryParse(_makingChargeController.text) ?? 0.0;

    if (weight <= 0) {
      setState(() {
        _hasCalculated = false;
        _calculatedResult = 0.0;
      });
      return;
    }

    if (_tabController.index == 0) {
      final double tax = double.tryParse(_taxController.text) ?? 0.0;
      setState(() {
        _baseGoldValue = weight * goldPrice24k;
        _makingChargeValue = weight * makingCharge;
        _taxOrCashbackValue = tax;
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
        _baseGoldValue = weight * goldPrice24k;
        _makingChargeValue = weight * makingCharge;
        _taxOrCashbackValue = weight * (makingCharge - cashback);
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

  // ميزة مشاركة النتائج بنسخ حسبة تفصيلية إلى الحافظة
  void _shareResults() {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final String type = _tabController.index == 0 ? 'حساب سعر الشراء' : 'حساب سعر إعادة الشراء (البيع)';
    
    final String shareText = '''
📊 حسبة الذهب الذكية التقديرية من منصة Gold Prices:
----------------------------------------
نوع العملية: $type
وزن السبيكة: $weight جرام
العيار المعتمد: عيار 24
----------------------------------------
💵 القيمة الأساسية للذهب: \$${_baseGoldValue.toStringAsFixed(2)}
🛠️ قيمة المصنعية الإجمالية: \$${_makingChargeValue.toStringAsFixed(2)}
⚖️ قيمة الضرائب / الفارق الصافي: \$${_taxOrCashbackValue.toStringAsFixed(2)}
----------------------------------------
💰 الإجمالي النهائي التقديري: \$${_calculatedResult.toStringAsFixed(2)}

* هذه الحسبة تقديرية واستشارية مبنية على أسعار البورصة الحالية.
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ تفاصيل الحسبة المالية بنجاح لمشاركتها!'),
        backgroundColor: Color(0xFF00BFA5),
      ),
    );
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
    final pricesAsync = ref.watch(priceProvider(1));
    double goldPrice24k = 3500.50;

    pricesAsync.whenData((prices) {
      final price24 = prices.firstWhere(
        (p) => p.karat == '24',
        orElse: () => prices.isNotEmpty ? prices.first : prices.first,
      );
      goldPrice24k = price24.price;
    });

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        title: const Text('الحاسبة المالية الذكية'),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'سعر الذهب الحالي المرجعي (عيار 24)',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    pricesAsync.maybeWhen(
                      data: (prices) {
                        return Text(
                          '\$${goldPrice24k.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                      orElse: () => const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Color(0xFF00BFA5), strokeWidth: 1.5),
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
            _buildInputField(controller: _makingChargeController, label: 'المصنعية للجرام الواحد', icon: Icons.monetization_on_outlined),
            const SizedBox(height: 16),
            
            if (_tabController.index == 0) ...[
              _buildInputField(controller: _taxController, label: 'الضرائب والرسوم الإجمالية', icon: Icons.gavel_outlined),
            ] else ...[
              _buildInputField(controller: _cashbackController, label: 'الكاش باك (Cashback) للجرام', icon: Icons.replay_outlined),
            ],
            
            const SizedBox(height: 28),
            
            // بطاقة عرض النتيجة والـ Breakdown التفصيلي للحسبة
            if (_hasCalculated) ...[
              _buildBreakdownCard(),
              const SizedBox(height: 20),
              
              // أزرار الحفظ والمشاركة
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _shareResults,
                        icon: const Icon(Icons.share, color: Colors.white, size: 18),
                        label: const Text('مشاركة الحسبة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BFA5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // محاكاة حفظ النتيجة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم حفظ الحسبة في سجل عملياتك المحلية بنجاح!'),
                              backgroundColor: Color(0xFF00BFA5),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bookmark_border, color: Color(0xFF00BFA5), size: 18),
                        label: const Text('حفظ النتيجة', style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00BFA5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // تلميح للمستخدم للبدء بالكتابة
              Container(
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Icon(Icons.edit_note, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'أدخل الوزن والمصنعية للقيام بحساب فوري وتلقائي أثناء الكتابة',
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
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

  // كرت تفصيلي (Breakdown Card) لعرض تفاصيل التكلفة
  Widget _buildBreakdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل التقسيم المالي (Breakdown)',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBreakdownRow('القيمة الأساسية للذهب (عيار 24)', '\$${_baseGoldValue.toStringAsFixed(2)}'),
          const Divider(color: Colors.white10),
          _buildBreakdownRow('قيمة المصنعية الإجمالية للوزن', '\$${_makingChargeValue.toStringAsFixed(2)}'),
          const Divider(color: Colors.white10),
          _buildBreakdownRow(
            _tabController.index == 0 ? 'قيمة الضرائب الإجمالية' : 'فارق كود إعادة الشراء (الخصم الصافي)',
            '\$${_taxOrCashbackValue.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF00BFA5), thickness: 1.2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _tabController.index == 0 ? 'السعر النهائي المالي التقديري' : 'صافي قيمة إعادة الشراء التقديرية',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculatedResult.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
