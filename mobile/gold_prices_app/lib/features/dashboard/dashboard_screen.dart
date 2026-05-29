import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/api_client.dart';
import '../prices/price_provider.dart';

class HistoryRecord {
  final String date;
  final int karat;
  final double price;
  final double change;

  HistoryRecord({
    required this.date,
    required this.karat,
    required this.price,
    required this.change,
  });
}

class DashboardScreen extends ConsumerStatefulWidget {
  final int countryId;
  const DashboardScreen({super.key, this.countryId = 1});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'أسبوع';
  
  // نقاط الرسم البياني المحاكاة لفترات مختلفة
  final Map<String, List<FlSpot>> _chartData = {
    '24 س': [
      const FlSpot(0, 3490),
      const FlSpot(1, 3495),
      const FlSpot(2, 3492),
      const FlSpot(3, 3498),
      const FlSpot(4, 3500),
      const FlSpot(5, 3500.5),
    ],
    'أسبوع': [
      const FlSpot(0, 3450),
      const FlSpot(1, 3470),
      const FlSpot(2, 3465),
      const FlSpot(3, 3485),
      const FlSpot(4, 3490),
      const FlSpot(5, 3500.5),
    ],
    'شهر': [
      const FlSpot(0, 3350),
      const FlSpot(1, 3380),
      const FlSpot(2, 3410),
      const FlSpot(3, 3450),
      const FlSpot(4, 3480),
      const FlSpot(5, 3500.5),
    ],
    'سنة': [
      const FlSpot(0, 2800),
      const FlSpot(1, 2950),
      const FlSpot(2, 3100),
      const FlSpot(3, 3300),
      const FlSpot(4, 3450),
      const FlSpot(5, 3500.5),
    ],
  };

  // حالة فلاتر الجدول المالي والـ API
  List<HistoryRecord> _historyRecords = [];
  bool _isHistoryLoading = false;
  
  String _selectedKarat = 'الكل';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // جلب السجل التاريخي الفوري من الـ API عند الإقلاع
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistory();
    });
  }

  // دالة جلب السجل التاريخي من الـ API بجميع خيارات الفلترة الديناميكية
  Future<void> _fetchHistory() async {
    setState(() => _isHistoryLoading = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      
      String path = 'prices/history?country_id=${widget.countryId}';
      if (_selectedKarat != 'الكل') {
        path += '&karat=$_selectedKarat';
      }
      if (_startDate != null) {
        path += '&start_date=${_startDate!.toIso8601String().split('T')[0]}';
      }
      if (_endDate != null) {
        path += '&end_date=${_endDate!.toIso8601String().split('T')[0]}';
      }

      final dynamic response = await apiClient.get(path);
      
      if (response is Map && response.containsKey('data')) {
        final List<dynamic> list = response['data'];
        setState(() {
          _historyRecords = list.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return HistoryRecord(
              date: map['created_at'].toString().split('T')[0],
              karat: int.parse(map['karat'].toString()),
              price: double.parse(map['price'].toString()),
              change: 0.25, // تغير افتراضي
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching history: $e');
    } finally {
      if (mounted) {
        setState(() => _isHistoryLoading = false);
      }
    }
  }

  // الحصول على رمز العملة بناءً على الدولة
  String _getCurrency() {
    switch (widget.countryId) {
      case 1: return 'EGP';
      case 2: return 'SAR';
      case 3: return 'AED';
      case 4: return 'KWD';
      default: return 'USD';
    }
  }

  String _getXAxisTitle(double value) {
    if (_selectedPeriod == '24 س') {
      switch (value.toInt()) {
        case 0: return '12:00';
        case 1: return '15:00';
        case 2: return '18:00';
        case 3: return '21:00';
        case 4: return '00:00';
        case 5: return '03:00';
      }
    } else if (_selectedPeriod == 'أسبوع') {
      switch (value.toInt()) {
        case 0: return '24 مايو';
        case 1: return '25 مايو';
        case 2: return '26 مايو';
        case 3: return '27 مايو';
        case 4: return '28 مايو';
        case 5: return '29 مايو';
      }
    } else if (_selectedPeriod == 'شهر') {
      switch (value.toInt()) {
        case 0: return 'أسبوع 1';
        case 1: return 'أسبوع 2';
        case 2: return 'أسبوع 3';
        case 3: return 'أسبوع 4';
        case 5: return 'اليوم';
      }
    } else {
      switch (value.toInt()) {
        case 0: return 'الربع 1';
        case 1: return 'الربع 2';
        case 2: return 'الربع 3';
        case 3: return 'الربع 4';
        case 5: return 'اليوم';
      }
    }
    return '';
  }

  // فتح نافذة اختيار التاريخ
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00BFA5),
              onPrimary: Colors.white,
              surface: Color(0xFF161616),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _fetchHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricesAsync = ref.watch(priceProvider(widget.countryId));
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
        title: const Text('لوحة التحكم المالي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Market Hero Section
            _buildMarketHeroCard(goldPrice24k, pricesAsync),
            const SizedBox(height: 24),
            
            // 2. Interactive Chart Section with Dates
            _buildInteractiveChartSection(),
            const SizedBox(height: 24),
            
            // 3. Historical Prices Table & Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجل الأسعار التاريخي (API)',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_startDate != null || _endDate != null || _selectedKarat != 'الكل')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedKarat = 'الكل';
                        _startDate = null;
                        _endDate = null;
                      });
                      _fetchHistory();
                    },
                    child: const Text('إعادة تعيين', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFilterWidget(),
            const SizedBox(height: 12),
            _buildHistoryTable(),
            const SizedBox(height: 24),
            
            // 4. Quick Karat Grid
            const Text(
              'بطاقات الأعيرة الفورية',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildKaratGrid(pricesAsync),
            const SizedBox(height: 24),
            
            // 5. Market Insights
            const Text(
              'تحليلات ونظرة على السوق (Market Insights)',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMarketInsights(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketHeroCard(double price24, AsyncValue pricesAsync) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF161616), Color(0xFF0F1B19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFA5).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سعر جرام الذهب عيار 24 بالعملة المحلية', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('الذهب الفوري المباشر (${_getCurrency()})', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFF00BFA5)),
                    SizedBox(width: 6),
                    Text('السوق مفتوح', style: TextStyle(color: Color(0xFF00BFA5), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              pricesAsync.maybeWhen(
                data: (data) {
                  return Text(
                    '${price24.toStringAsFixed(2)} ${_getCurrency()}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  );
                },
                orElse: () => const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(color: Color(0xFF00BFA5), strokeWidth: 2),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 20),
                  SizedBox(width: 4),
                  Text(
                    '+0.25%',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('آخر تحديث مباشر للبورصة:', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('منذ ثوانٍ قليلة', style: TextStyle(color: Color(0xFF00BFA5), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInteractiveChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تحليل اتجاه الأسعار التاريخي', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: ['24 س', 'أسبوع', 'شهر', 'سنة'].map((period) {
                  final isSelected = _selectedPeriod == period;
                  return InkWell(
                    onTap: () => setState(() => _selectedPeriod = period),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF00BFA5) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _getXAxisTitle(value),
                            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _chartData[_selectedPeriod]!,
                    isCurved: true,
                    color: const Color(0xFF00BFA5),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00BFA5).withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت الفلاتر التفاعلية لتاريخ الأسعار
  Widget _buildFilterWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تصفية العيار:', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedKarat,
                dropdownColor: const Color(0xFF161616),
                underline: const SizedBox(),
                style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
                items: const [
                  DropdownMenuItem(value: 'الكل', child: Text('جميع الأعيرة')),
                  DropdownMenuItem(value: '24', child: Text('عيار 24')),
                  DropdownMenuItem(value: '21', child: Text('عيار 21')),
                  DropdownMenuItem(value: '18', child: Text('عيار 18')),
                ],
                onChanged: (val) {
                  setState(() => _selectedKarat = val!);
                  _fetchHistory();
                },
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, true),
                  icon: const Icon(Icons.date_range, size: 16, color: Color(0xFF00BFA5)),
                  label: Text(
                    _startDate == null ? 'تاريخ البدء' : _startDate!.toIso8601String().split('T')[0],
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, false),
                  icon: const Icon(Icons.date_range, size: 16, color: Color(0xFF00BFA5)),
                  label: Text(
                    _endDate == null ? 'تاريخ الانتهاء' : _endDate!.toIso8601String().split('T')[0],
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    if (_isHistoryLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
        ),
      );
    }

    if (_historyRecords.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade900),
        ),
        child: const Center(
          child: Text('لا توجد سجلات تاريخية تطابق الفلترة المحددة.', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        children: [
          // رأس الجدول
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('التاريخ واليوم', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13))),
                Expanded(child: Text('العيار', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
                Expanded(child: Text('سعر الجرام المالي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
                Expanded(child: Text('نسبة التغير اليومية', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.end)),
              ],
            ),
          ),
          
          // محتويات الجدول التاريخي المجلوب من الـ API
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _historyRecords.length,
            itemBuilder: (context, index) {
              final record = _historyRecords[index];
              final isUp = record.change >= 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        record.date,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'عيار ${record.karat}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${record.price.toStringAsFixed(1)} ${_getCurrency()}',
                        style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 13, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            isUp ? Icons.trending_up : Icons.trending_down,
                            color: isUp ? Colors.greenAccent : Colors.redAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isUp ? "+" : ""}${record.change.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isUp ? Colors.greenAccent : Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildKaratGrid(AsyncValue pricesAsync) {
    return pricesAsync.maybeWhen(
      data: (prices) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: prices.take(3).length,
          itemBuilder: (context, index) {
            final price = prices[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade900),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عيار ${price.karat}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${price.price.toStringAsFixed(1)} ${_getCurrency()}',
                    style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
                      SizedBox(width: 4),
                      Text('+0.2%', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      orElse: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
      ),
    );
  }

  Widget _buildMarketInsights() {
    final List<Map<String, dynamic>> insights = [
      {
        'title': 'أثر مؤشر الدولار الأمريكي',
        'desc': 'مؤشر الدولار مستقر حالياً، مما يعطي فرصة للاستقرار لأسعار الذهب.',
        'icon': Icons.attach_money,
        'color': Colors.amber,
      },
      {
        'title': 'طلب الأسواق العالمية',
        'desc': 'ارتفاع خفيف في الطلب الموسمي يرفع التوقعات الإيجابية لحركة الغد.',
        'icon': Icons.trending_up,
        'color': Colors.greenAccent,
      },
    ];

    return Column(
      children: insights.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade900),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'], color: item['color']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc'],
                      style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
