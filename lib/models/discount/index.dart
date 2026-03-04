class Discount {
  static final Discount _instance = Discount._internal();
  String? promotionCode;
  String? planId;
  String? versionId;
  double? amount;
  bool? requirePayment;

  static Discount instance() => _instance;

  Discount._internal();

  void setAmount(int discountedAmount){
    amount = discountedAmount / 100;
  }

  void setRequirePayment(bool requirePayment){
    this.requirePayment = requirePayment;
  }
}