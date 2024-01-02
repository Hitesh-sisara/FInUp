import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/models/bill_model.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardBillSection extends ConsumerWidget {
  final CreditCard creditCard;

  const CreditCardBillSection({
    Key? key,
    required this.creditCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Bill?>(
      future: ref.watch(billerAPIProvider).findLatestBill(creditCard.id),
      builder: (context, AsyncSnapshot<Bill?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          print("data : ${snapshot.data}");

          int daysUntilDue = calculateDaysUntilDueDate();
          String status = daysUntilDue >= 0 ? 'Paid' : 'Due';
          Color chipColor = daysUntilDue >= 0 ? Colors.green : Colors.blue;

          return buildGenericBillSection(daysUntilDue);
        } else {
          final bill = snapshot.data!;
          int daysDifference =
              snapshot.data!.dueDate.difference(DateTime.now()).inDays;

          String status = " due";
          Color chipColor = Colors.blue;

          calculateStatusAndColor(daysDifference, outStatus: (value) {
            status = value;
          }, outChipColor: (value) {
            chipColor = value;
          });

          return buildBillSection('Due Date: ${bill.dueDate}', chipColor,
              billAmount: 'Bill Amount: ${bill.amount}', status: status);
        }
      },
    );
  }

  Widget buildGenericBillSection(
    int dueDate,
  ) {
    return Column(
      children: [
        Chip(
          label: Text("Bill data not available"),
          color: MaterialStateColor.resolveWith((states) => Colors.grey),
        ),
        Text(
          "Expected bill due in : $dueDate Days",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildBillSection(
    String dueDate,
    Color chipColor, {
    String billAmount = '',
    String status = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dueDate,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (billAmount.isNotEmpty)
          Text(
            billAmount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        Chip(
          label: Text(status),
          backgroundColor: chipColor,
        ),
      ],
    );
  }

  int calculateDaysUntilDueDate() {
    int currentDay = DateTime.now().day;
    int dueDate = creditCard.intDueDate;

    if (currentDay <= dueDate) {
      // If current day is on or before the due date, calculate the difference straightforward
      return dueDate - currentDay;
    } else {
      // If current day is after the due date, calculate the remaining days in the month
      DateTime lastDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
      int remainingDaysInMonth = lastDayOfMonth.day - currentDay;

      // Calculate the days until due date by adding the remaining days in the month and the due date
      return remainingDaysInMonth + dueDate;
    }
  }

  void calculateStatusAndColor(
    int daysDifference, {
    required void Function(String) outStatus,
    required void Function(Color) outChipColor,
  }) {
    Color chipColor = Colors.blue; // Provide an initial value

    if (daysDifference < 0) {
      outStatus('Paid');
      chipColor = Colors.green;
    } else if (daysDifference <= 7) {
      outStatus('Due in $daysDifference days');
      chipColor = Colors.orange;
    } else if (daysDifference <= 3) {
      outStatus('Due in $daysDifference days');
      chipColor = Colors.red;
    } else if (daysDifference <= 15) {
      outStatus('Due in $daysDifference days');
      chipColor = Colors.yellow;
    } else {
      outStatus('Due in $daysDifference days');
      // No need to assign chipColor in this branch, it already has the initial value
    }

    // Now, chipColor is guaranteed to be assigned, and the error should be resolved.
    outChipColor(chipColor);
  }
}
