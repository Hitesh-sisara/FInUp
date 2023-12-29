import 'package:finup/UI/billers/credit_card/add_new_bill.dart';
import 'package:flutter/material.dart';

void showAddSheetCreditCard(BuildContext context, String accountId) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.receipt_long_outlined),
              title: Text('Add New Bill'),
              onTap: () {
                showAddBillBottomSheet(context, accountId);
                // Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward_outlined),
              title: Text('New Debit Transaction'),
              onTap: () {
                // Handle adding new debit transaction here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_upward_outlined),
              title: Text('New Credit Transaction'),
              onTap: () {
                // Handle adding new credit transaction here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
