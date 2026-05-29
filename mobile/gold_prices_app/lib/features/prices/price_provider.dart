import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import 'price_model.dart';
import 'price_repository.dart';

// Provider for PriceRepository
final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  return PriceRepository(ref.read(apiClientProvider));
});

// StateNotifier for managing price state
class PriceNotifier extends StateNotifier<AsyncValue<List<PriceModel>>> {
  final PriceRepository _repository;

  PriceNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchPrices(int countryId) async {
    state = const AsyncValue.loading();
    try {
      final prices = await _repository.getLatestPrices(countryId);
      state = AsyncValue.data(prices);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for PriceNotifier
final priceProvider = StateNotifierProvider.family<PriceNotifier, AsyncValue<List<PriceModel>>, int>((ref, countryId) {
  final repository = ref.read(priceRepositoryProvider);
  return PriceNotifier(repository)..fetchPrices(countryId);
});
