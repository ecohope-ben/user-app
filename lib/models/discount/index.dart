class Discount {
  static final Discount _instance = Discount._internal();
  String? promotionCode;
  String? planId;
  String? versionId;
  double? amount;

  static Discount instance() => _instance;

  Discount._internal();

  void setAmount(int discountedAmount){
    amount = discountedAmount / 100;
  }
}