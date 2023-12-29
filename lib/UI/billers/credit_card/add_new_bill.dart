import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/common/widgets/utils.dart';
import 'package:finup/models/bill_model.dart';

void showAddBillBottomSheet(BuildContext context, String accountId) {
  showModalBottomSheet(
    context: context,
    builder: (context) => AddBillBottomSheet(accountId: accountId),
  );
}

class AddBillBottomSheet extends ConsumerStatefulWidget {
  final String accountId;

  const AddBillBottomSheet({super.key, required this.accountId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddBillBottomSheetState();
}

class _AddBillBottomSheetState extends ConsumerState<AddBillBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  bool isLoading = false;

  Future<void> _postBill() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final bill = Bill(
          id: '',
          account: widget.accountId,
          amount: int.parse(amountController.text.trim()),
          dueDate: DateTime.parse(dueDateController.text),
          billDate: DateTime.parse(billDateController.text),
        );

        await ref.read(billerAPIProvider).addNewBill(bill);

        Navigator.of(context).pop();

        context.showAlert("Bill added succsessfully");
      } catch (error) {
        debugPrint('Error adding Bill: $error');
        await context.showAlertDialog(
          content: 'Failed to add Bill. Please try again.',
        );
      } finally {
        setState(() => isLoading = false);
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
