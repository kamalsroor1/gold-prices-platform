import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';
import 'bullion_model.dart';
import 'bullion_repository.dart';

final bullionRepositoryProvider = Provider<BullionRepository>((ref) {
  return BullionRepository(ApiClient());
});

class BullionNotifier extends StateNotifier<AsyncValue<List<BullionModel>>> {
  final BullionRepository _repository;

  BullionNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchBullions(int countryId) async {
    state = const AsyncValue.loading();
    try {
      final bullions = await _repository.getBullions(countryId);
      state = AsyncValue.data(bullions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final bullionProvider = StateNotifierProvider.family<BullionNotifier, AsyncValue<List<BullionModel>>, int>((ref, countryId) {
  final repository = ref.read(bullionRepositoryProvider);
  return BullionNotifier(repository)..fetchBullions(countryId);
});
