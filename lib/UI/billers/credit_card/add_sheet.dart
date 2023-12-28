import 'package:flutter/material.dart';

void showAddSheetCreditCard(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
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
                // Handle adding new bill here
                Navigator.pop(context); // Close the bottom sheet
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
