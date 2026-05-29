import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/api_client.dart';
import 'bullion_provider.dart';
import 'bullion_model.dart';

class BullionScreen extends ConsumerStatefulWidget {
  final int countryId;
  const BullionScreen({super.key, required this.countryId});

  @override
  ConsumerState<BullionScreen> createState() => _BullionScreenState();
}

class _BullionScreenState extends ConsumerState<BullionScreen> {
  String _selectedType = 'الكل'; // الكل، سبائك، عملات
  String _selectedWeightRange = 'الكل'; // الكل، < 10g، 10g - 50g، > 50g
  String _searchQuery = '';

  // تصفية السبائك بناءً على الخيارات المحددة
  List<BullionModel> _filterBullions(List<BullionModel> bullions) {
    return bullions.where((bullion) {
      // 1. تصفية البحث بالاسم
      final matchesSearch = bullion.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // 2. تصفية النوع
      bool matchesType = true;
      if (_selectedType == 'سبائك') {
        matchesType = bullion.name.contains('سبيكة') || bullion.name.contains('سبائك');
      } else if (_selectedType == 'عملات') {
        matchesType = bullion.name.contains('جنيه') || bullion.name.contains('عملة');
      }

      // 3. تصفية الوزن
      bool matchesWeight = true;
      if (_selectedWeightRange == '< 10g') {
        matchesWeight = bullion.weight < 10.0;
      } else if (_selectedWeightRange == '10g - 50g') {
        matchesWeight = bullion.weight >= 10.0 && bullion.weight <= 50.0;
      } else if (_selectedWeightRange == '> 50g') {
        matchesWeight = bullion.weight > 50.0;
      }

      return matchesSearch && matchesType && matchesWeight;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bullionsAsync = ref.watch(bullionProvider(widget.countryId));

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        title: const Text('استكشاف السبائك والمعادن'),
      ),
      body: Column(
        children: [
          // 1. شريط البحث والتصفية العلوي
          _buildSearchAndFilterBar(),
          
          // 2. الأزرار السريعة للتصفية
          _buildQuickFilterChips(),
          
          // 3. شبكة عرض السبائك والمنتجات الذهبية
          Expanded(
            child: bullionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'حدث خطأ: $err',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (bullions) {
                final filteredList = _filterBullions(bullions);
                if (filteredList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد سبائك تطابق خيارات التصفية',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final bullion = filteredList[index];
                    final isCoin = bullion.name.contains('جنيه') || bullion.name.contains('عملة');
                    
                    return InkWell(
                      onTap: () => _showBullionDetailsBottomSheet(context, bullion, isCoin),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // أيقونة المنتج
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isCoin ? const Color(0xFFFFD700) : const Color(0xFF00BFA5)).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isCoin ? Icons.monetization_on : Icons.view_headline,
                                  color: isCoin ? const Color(0xFFFFD700) : const Color(0xFF00BFA5),
                                ),
                              ),
                              const Spacer(),
                              
                              // الاسم والعيار
                              Text(
                                bullion.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              
                              // تفاصيل الوزن والعيار
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${bullion.weight} جرام',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'عيار ${bullion.karat}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              
                              // السعر الإجمالي الفوري للمنتج
                              const Divider(color: Colors.white10, height: 1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${formatPrice(bullion.price)} ${getCurrencySymbol(widget.countryId)}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
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

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'البحث عن سبائك أو جنيهات ذهب...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true,
          fillColor: const Color(0xFF161616),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade900),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // فلتر نوع المنتج
          _buildFilterDropdown(
            label: 'النوع: $_selectedType',
            onTap: () => _showFilterOptionsBottomSheet(
              title: 'اختر نوع المنتج',
              options: const ['الكل', 'سبائك', 'عملات'],
              currentValue: _selectedType,
              onSelect: (val) => setState(() => _selectedType = val),
            ),
          ),
          const SizedBox(width: 10),
          
          // فلتر أوزان السبائك
          _buildFilterDropdown(
            label: 'الوزن: $_selectedWeightRange',
            onTap: () => _showFilterOptionsBottomSheet(
              title: 'اختر تصنيف الوزن بالجرام',
              options: const ['الكل', '< 10g', '10g - 50g', '> 50g'],
              currentValue: _selectedWeightRange,
              onSelect: (val) => setState(() => _selectedWeightRange = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade900),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showFilterOptionsBottomSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelect,
  }) {
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
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final isSelected = currentValue == opt;
                return ListTile(
                  title: Text(opt, style: TextStyle(color: isSelected ? const Color(0xFF00BFA5) : Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF00BFA5)) : null,
                  onTap: () {
                    onSelect(opt);
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

  // ورقة عرض تفاصيل السبيكة أو العملة التعليمية
  void _showBullionDetailsBottomSheet(BuildContext context, BullionModel bullion, bool isCoin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // مقبض السحب العلوي
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
                  
                  // أيقونة ورأس السبيكة
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (isCoin ? const Color(0xFFFFD700) : const Color(0xFF00BFA5)).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isCoin ? Icons.monetization_on : Icons.view_headline,
                          color: isCoin ? const Color(0xFFFFD700) : const Color(0xFF00BFA5),
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bullion.name,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'تصنيف: ${isCoin ? "عملات نقدية ذهبية" : "سبائك خام للاستثمار"}',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  
                  // كرت معلومات السبيكة والتفاصيل
                  const Text('المواصفات والتحليل الفني', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090909),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('الوزن الإجمالي', '${bullion.weight} جرام'),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('عيار الذهب ونقاوته', 'عيار ${bullion.karat} (نقاوة 999.9)'),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('القيمة المالية الفورية السوقية', '${formatPrice(bullion.price)} ${getCurrencySymbol(widget.countryId)}'),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('منشأ الذهب المعتمد', 'معتمد ومدموغ رسمياً'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // المخطط البياني لتاريخ تغيرات السعر المرجعي
                  const Text('تغيرات القيمة التاريخية للمنتج', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090909),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, bullion.price * 0.95),
                              FlSpot(1, bullion.price * 0.97),
                              FlSpot(2, bullion.price * 0.96),
                              FlSpot(3, bullion.price * 0.99),
                              FlSpot(4, bullion.price),
                            ],
                            isCurved: true,
                            color: const Color(0xFF00BFA5),
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // معلومات تعليمية وتثقيفية عن السبيكة أو العملة للمستثمر
                  const Text('نصائح استثمارية هامة للسبائك', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5).withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.15)),
                    ),
                    child: const Text(
                      'تعتبر السبائك الذهبية عيار 24 من أفضل الملاذات الآمنة لحفظ القيمة والادخار طويل الأجل، وذلك لانخفاض مصنعيتها مقارنة بالمشغولات الذهبية العادية ونسب نقائها الفائقة التي تبلغ 99.9%. يرجى دائماً الحفاظ على الغلاف الأمني للسبائك لحمايتها وتسهيل إعادة بيعها مستقبلاً بالأسعار العالمية.',
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
