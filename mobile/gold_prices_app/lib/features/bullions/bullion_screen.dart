import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bullion_provider.dart';

class BullionScreen extends ConsumerWidget {
  final int countryId;
  const BullionScreen({super.key, required this.countryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bullionsAsync = ref.watch(bullionProvider(countryId));

    return Scaffold(
      appBar: AppBar(title: const Text('السبائك والعملات الذهبية')),
      body: bullionsAsync.when(
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
          if (bullions.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد سبائك معروضة حالياً',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: bullions.length,
            itemBuilder: (context, index) {
              final bullion = bullions[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.monetization_on, color: Color(0xFFFFD700)),
                      ),
                      const Spacer(),
                      Text(
                        bullion.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الوزن: ${bullion.weight} جرام',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Text(
                        'العيار: ${bullion.karat}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '\$${bullion.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
