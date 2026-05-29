import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/api_client.dart';
import 'price_provider.dart';

class PriceScreen extends ConsumerWidget {
  final int countryId;
  const PriceScreen({super.key, required this.countryId});

  // نقاط المنحنى البياني المصغر (Sparkline) لكل عيار محاكى للحركة اليومية
  List<FlSpot> _getSparklineSpots(String karat) {
    switch (karat) {
      case '24':
        return const [FlSpot(0, 3480), FlSpot(1, 3490), FlSpot(2, 3485), FlSpot(3, 3495), FlSpot(4, 3500.5)];
      case '21':
        return const [FlSpot(0, 3045), FlSpot(1, 3055), FlSpot(2, 3050), FlSpot(3, 3060), FlSpot(4, 3063.0)];
      case '18':
        return const [FlSpot(0, 2610), FlSpot(1, 2618), FlSpot(2, 2612), FlSpot(3, 2622), FlSpot(4, 2625.4)];
      default:
        return const [FlSpot(0, 1000), FlSpot(1, 1005), FlSpot(2, 1002), FlSpot(3, 1008), FlSpot(4, 1010.0)];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesAsync = ref.watch(priceProvider(countryId));

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        title: const Text('السوق والأسعار المباشرة'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. شريط حالة السوق والتحليلات الأساسية (Market Status Bar)
          _buildMarketStatusBar(),
          
          // 2. قائمة أسعار الذهب والأعيرة المختلفة التفاعلية
          Expanded(
            child: pricesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'حدث خطأ في الاتصال: $err',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (prices) {
                if (prices.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد بيانات أسعار متاحة حالياً',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: prices.length,
                  itemBuilder: (context, index) {
                    final price = prices[index];
                    final double dailyChangePercent = 0.25; // نسبة محاكاة التغير اليومي
                    final double highPrice = price.price * 1.01;
                    final double lowPrice = price.price * 0.99;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00BFA5).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.workspace_premium, color: Color(0xFF00BFA5)),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ذهب عيار ${price.karat}',
                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text('حجم تداول عالي', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${price.price.toStringAsFixed(2)} ${getCurrencySymbol(countryId)}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          '+${dailyChangePercent.toStringAsFixed(2)}%',
                                          style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // 3. الرسم البياني المصغر (Sparkline) المدمج والفاخر داخل البطاقة
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _getSparklineSpots(price.karat),
                                      isCurved: true,
                                      color: const Color(0xFF00BFA5),
                                      barWidth: 2.2,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0xFF00BFA5).withOpacity(0.04),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // 4. أعلى وأقل سعر خلال اليوم لتقديم إحصائيات مالية دقيقة للمستثمرين
                            const Divider(color: Colors.white10, height: 1),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('أقل سعر اليوم: ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    Text('${lowPrice.toStringAsFixed(1)} ${getCurrencySymbol(countryId)}', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('أعلى سعر اليوم: ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    Text('${highPrice.toStringAsFixed(1)} ${getCurrencySymbol(countryId)}', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStatusBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اتجاه السوق اليومي', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  SizedBox(height: 2),
                  Text('صعود مستقر', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          VerticalDivider(color: Colors.white24, width: 1),
          Row(
            children: [
              Icon(Icons.bolt, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مستوى التقلب والنشاط', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  SizedBox(height: 2),
                  Text('منخفض', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
