class CreditCard {
  String bank;
  String cardName;
  int? creditLimit;
  int last4Digits;
  String? lastPayment; // Using UuidValue for lastPayment
  String userId; // Using UuidValue for userId
  int intBillDate;
  int intDueDate;

  CreditCard({
    required this.bank,
    required this.cardName,
    required this.creditLimit,
    required this.last4Digits,
    this.lastPayment,
    required this.userId,
    required this.intBillDate,
    required this.intDueDate,
  });

  // Factory constructor for creating CreditCard from JSON
  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      bank: json['bank'] as String,
      cardName: json['card_name'] as String,
      creditLimit: json['credit_limit'] as int?,
      last4Digits: json['last_4_digits'] as int,
      lastPayment: json['last_payment'] as String?,
      userId: json['user_id'] as String,
      intBillDate: json['int_bill_date'] as int,
      intDueDate: json['int_due_date'] as int,
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
