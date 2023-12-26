class CreditCard {
  String id;
  String bank;
  String cardName;
  int? creditLimit;
  int last4Digits;
  String? lastPayment; // Using UuidValue for lastPayment
  String userId; // Using UuidValue for userId
  int intBillDate;
  int intDueDate;

  CreditCard({
    required this.id,
    required this.bank,
    required this.cardName,
    required this.creditLimit,
    required this.last4Digits,
    this.lastPayment,
    required this.userId,
    required this.intBillDate,
    required this.intDueDate,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      bank: json['bank'] as String,
      cardName: json['cardName'] as String,
      creditLimit: json['credit_limit'] as int?,
      last4Digits: json['last4Digits'] as int,
      lastPayment: json['lastPayment'] as String?,
      userId: json['userId'] as String,
      intBillDate: json['intBillDate'] as int,
      intDueDate: json['intDueDate'] as int,
    );
  }

  // Convert CreditCard to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'cardName': cardName,
      'creditLimit': creditLimit,
      'last4Digits': last4Digits,
      'intBillDate': intBillDate,
      'intDueDate': intDueDate,
    };
  }
}
