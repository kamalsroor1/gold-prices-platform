import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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

  // سجل العمليات والأسعار التاريخية للجدول المالي
  final List<HistoryRecord> _historyRecords = [
    HistoryRecord(date: '2026-05-29', karat: 24, price: 3500.50, change: 0.25),
    HistoryRecord(date: '2026-05-28', karat: 24, price: 3490.00, change: 0.15),
    HistoryRecord(date: '2026-05-27', karat: 24, price: 3485.50, change: -0.12),
    HistoryRecord(date: '2026-05-26', karat: 24, price: 3492.00, change: 0.35),
    HistoryRecord(date: '2026-05-25', karat: 24, price: 3470.00, change: 0.05),
    HistoryRecord(date: '2026-05-24', karat: 24, price: 3465.00, change: -0.20),
    HistoryRecord(date: '2026-05-23', karat: 24, price: 3450.00, change: 0.10),
  ];

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
            
            // 3. Historical Prices Table
            const Text(
              'جدول السجل التاريخي للأسعار',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سعر الأونصة العالمي عيار 24', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('الذهب الفوري المباشر', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                    '\$${price24.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
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

  Widget _buildHistoryTable() {
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
                Expanded(child: Text('العيار المعتمد', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
                Expanded(child: Text('سعر الجرام المالي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
                Expanded(child: Text('نسبة التغير اليومية', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.end)),
              ],
            ),
          ),
          
          // محتويات الجدول التاريخي
          ..._historyRecords.map((record) {
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
                      '\$${record.price.toStringAsFixed(2)}',
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
          }).toList(),
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
                    '\$${price.price.toStringAsFixed(1)}',
                    style: const TextStyle(color: Color(0xFF00BFA5), fontSize: 16, fontWeight: FontWeight.bold),
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
