import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardBillSection extends ConsumerWidget {
  final CreditCard creditCard;
  const CreditCardBillSection({
    super.key,
    required this.creditCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: BillerAPI().findLatestBill(creditCard.id),
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.hasError) {
          return Text('No bill data available.');
        } else {
          // Display due date and bill amount
          final dueDate = snapshot.data!['due_date'];
          final billAmount = snapshot.data!['amount'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due Date: $dueDate',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Bill Amount: $billAmount',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
