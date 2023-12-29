import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showAddBillBottomSheet(BuildContext context, String accountId) {
  showModalBottomSheet(
    context: context,
    builder: (context) => AddBillBottomSheet(accountId: accountId),
  );
}

class AddBillBottomSheet extends StatefulWidget {
  final String accountId;

  const AddBillBottomSheet({Key? key, required this.accountId})
      : super(key: key);

  @override
  State<AddBillBottomSheet> createState() => _AddBillBottomSheetState();
}

class _AddBillBottomSheetState extends State<AddBillBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController billDateController = TextEditingController();

  Future<void> _postBill() async {
    if (_formKey.currentState!.validate()) {
      try {} catch (error) {
        // Handle network or other errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
            ),
            TextFormField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020), // Adjust as needed
                  lastDate: DateTime(2030), // Adjust as needed
                );
                if (selectedDate != null) {
                  dueDateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
            ),
            TextFormField(
              controller: billDateController,
              decoration: InputDecoration(labelText: 'Bill Date'),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020), // Adjust as needed
                  lastDate: DateTime(2030), // Adjust as needed
                );
                if (selectedDate != null) {
                  billDateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _postBill,
              child: Text('Add Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
