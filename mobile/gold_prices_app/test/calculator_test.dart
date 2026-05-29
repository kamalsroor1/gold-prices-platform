import 'package:flutter_test/flutter_test.dart';
import 'package:gold_prices_app/features/calculator/calculator_service.dart';

void main() {
  group('CalculatorService Tests', () {
    test('Should calculate Selling Price correctly', () {
      final result = CalculatorService.calculateSellingPrice(
        weight: 10.0,
        goldPrice24k: 100.0,
        makingCharge: 5.0,
        tax: 20.0,
      );
      // (10 * 100) + (10 * 5) + 20 = 1000 + 50 + 20 = 1070
      expect(result, 1070.0);
    });

    test('Should calculate Buyback Price correctly', () {
      final result = CalculatorService.calculateBuybackPrice(
        weight: 10.0,
        goldPrice24k: 100.0,
        makingCharge: 5.0,
        cashback: 2.0,
      );
      // (10 * 100) - (10 * (5 - 2)) = 1000 - (10 * 3) = 1000 - 30 = 970
      expect(result, 970.0);
    });

    test('Should return 0 for zero or negative values', () {
      final result = CalculatorService.calculateSellingPrice(
        weight: -5.0,
        goldPrice24k: 100.0,
        makingCharge: 5.0,
        tax: 20.0,
      );
      expect(result, 0.0);
    });
  });
}
