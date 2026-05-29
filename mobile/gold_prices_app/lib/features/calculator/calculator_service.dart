class CalculatorService {
  /// معادلة حساب سعر الشراء النهائي
  /// سعر السبيكة = (وزن السبيكة × سعر جرام عيار 24) + (وزن السبيكة × المصنعية للجرام) + الضرائب
  static double calculateSellingPrice({
    required double weight,
    required double goldPrice24k,
    required double makingCharge,
    required double tax,
  }) {
    if (weight <= 0 || goldPrice24k <= 0) return 0.0;
    return (weight * goldPrice24k) + (weight * makingCharge) + tax;
  }

  /// معادلة حساب سعر إعادة الشراء
  /// سعر إعادة الشراء = (وزن السبيكة × سعر جرام عيار 24 الحالي) - (وزن السبيكة × (المصنعية - الكاش باك))
  static double calculateBuybackPrice({
    required double weight,
    required double goldPrice24k,
    required double makingCharge,
    required double cashback,
  }) {
    if (weight <= 0 || goldPrice24k <= 0) return 0.0;
    return (weight * goldPrice24k) - (weight * (makingCharge - cashback));
  }
}
