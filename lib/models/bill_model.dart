class Bill {
  DateTime? createdAt;
  String account; // Using String for account
  int amount;
  DateTime dueDate;
  DateTime billDate;
  String id; // Using String for ID

  // Constructor with default values
  Bill({
    required this.account,
    required this.amount,
    required this.dueDate,
    required this.billDate,
    this.createdAt,
    required this.id, // Generate a UUID as a String
  });

  // Factory constructor from database maps
  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        createdAt: DateTime.parse(json['created_at']),
        account: json['account'] as String,
        amount: json['amount'] as int,
        dueDate: DateTime.parse(json['due_date']),
        billDate: DateTime.parse(json['bill_date']),
        id: json['id'] as String,
      );

  // Convert to Map for database operations
  // Map<String, dynamic> toMap() {
  //   return {
  //     'account': account,
  //     'amount': amount,
  //     'due_date': dueDate,
  //     'bill_date': billDate,
  //   };
  // }

  Map<String, dynamic> toJson() => {
        'account': account,
        'amount': amount,
        'due_date': dueDate.toIso8601String(),
        'bill_date': billDate.toIso8601String(),
      };

  // Create a Bill instance from a JSON Map
  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      createdAt: map['created_at'] as DateTime,
      account: map['account'] as String,
      amount: map['amount'] as int,
      dueDate: map['due_date'] as DateTime,
      billDate: map['bill_date'] as DateTime,
      id: map['id'] as String,
    );
  }
}
