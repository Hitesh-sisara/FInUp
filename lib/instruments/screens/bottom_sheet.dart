import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/common/widgets/long_button.dart';
import 'package:finup/common/widgets/small_icon_button.dart';
import 'package:finup/common/widgets/utils.dart';
import 'package:finup/core/providers/cc_bank_list_provider.dart';
import 'package:finup/core/providers/cc_list_for_given_bank_provider.dart';
import 'package:finup/instruments/screens/fancy_droop_down_button.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AddNewCrediCard extends ConsumerStatefulWidget {
  const AddNewCrediCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewCrediCardState();
}

class _AddNewCrediCardState extends ConsumerState<AddNewCrediCard> {
  String? selectedBank;
  String? _selectedCreditCard;

  List<String> ccList = [];
  bool isLoadingCCList = false;

  bool _isCardDeatiledFilled = false;

  final TextEditingController last4DigitsController = TextEditingController();
  final TextEditingController creditLimitController = TextEditingController();

  int? _selectedBillGenerationDate;
  int? _selectedDueDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ...

  @override
  void dispose() {
    last4DigitsController.dispose();
    creditLimitController.dispose();
    super.dispose();
  }

  Future<void> _submitCreditCardData() async {
    if (_selectedBillGenerationDate != null && _selectedDueDate != null) {
      try {
        final creditCard = CreditCard(
          userId: '',
          bank: selectedBank!,
          cardName: _selectedCreditCard!,
          last4Digits: int.parse(last4DigitsController.text.trim()),
          creditLimit: int.parse(creditLimitController.text),
          intBillDate: _selectedBillGenerationDate!,
          intDueDate: _selectedDueDate!,
        );

        print(creditCard.toJson());

        final response =
            ref.read(addBillerAPIProvider).addCreditCard(creditCard);

        print(response.toString());

        if (response != null) {
          await context.showAlertDialog(
            content: 'Credit card added successfully!',
            defaultActionText: 'OK',
          );
          context.pop();
        }
      } catch (error) {
        debugPrint('Error adding credit card: $error');
        await context.showAlertDialog(
          content: 'Failed to add credit card. Please try again.',
          defaultActionText: 'OK',
        );
      }
    } else {
      await context.showAlertDialog(content: "select both Dates");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankListFuture = ref.read(ccBankListProvider).get_cc_banks_list();

    return SizedBox(
      width: 1.sw,
      height: 300.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Add  Credit Card'),
            const SizedBox(height: 20),
            // ... other input fields

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedBank == null) _bankSelector(),
                  // Show only if bank isn't selected
                  if (selectedBank != null && _selectedCreditCard == null)
                    if (selectedBank!.isNotEmpty) _creditCardSelector(),

                  // if (_selectedCreditCard != null)
                  //   _buildCreditCardDetailsFields(),

                  if (_selectedCreditCard != null && !_isCardDeatiledFilled)
                    _buildCreditCardDetailsFields(),

                  if (_isCardDeatiledFilled) _buildBillAndDueDateFields(),
                ],
              ),
            ),

            SizedBox(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _bankSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bank Name'),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: ref.read(ccBankListProvider).get_cc_banks_list(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bankNames = snapshot.data!.toSet().toList();

                return FancyDropdownButton(
                  title:
                      selectedBank ?? 'Select Bank', // Use null-aware operator
                  items: bankNames.map((bank) => bank).toList(),
                  value: selectedBank,
                  onChanged: (value) async {
                    setState(() {
                      selectedBank = value!;
                      isLoadingCCList = true;
                      ccList = [];
                    });

                    final fetchedCCList = await ref
                        .read(ccListForBankProvider)
                        .getCCList(selectedBank!);

                    setState(() {
                      ccList = fetchedCCList;
                      isLoadingCCList = false;
                    });
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error fetching bank list');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _creditCardSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Credit Card Name'),
          const SizedBox(height: 8),
          isLoadingCCList
              ? const CircularProgressIndicator()
              : FancyDropdownButton(
                  title: _selectedCreditCard ?? 'Select Credit Card',
                  items: ccList.map((cc) => cc).toList(),
                  value: _selectedCreditCard, // Track the selected card
                  onChanged: (value) {
                    setState(() {
                      _selectedCreditCard = value!; // Update selected card
                    });
                    // ... Perform actions based on credit card selection
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildCreditCardDetailsFields() {
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: last4DigitsController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Last 4 digits of card number',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the last 4 digits';
                    }
                    return null; // Validation passes
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: creditLimitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Credit limit',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter the credit limit';
                    }

                    if (int.tryParse(value) == null) {
                      return 'enter a numeric value'; // Ensure numeric input
                    }
                    return null; // Validation passes
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: Row(
            children: [
              SizedBox(width: 60.w),
              Center(
                child: MyIconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_right,
                    color: Theme.of(context).canvasColor,
                  ),
                  ontap: () {
                    // Check for validation errors
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isCardDeatiledFilled = true;
                      });
                      // If validation passes, proceed to the next screen (provide navigation logic here)
                      // Replace with your next screen's route
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectBillGenerationDate() async {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Calculate the adjusted previous month and year
    int adjustedPreviousMonth;
    int adjustedPreviousYear;

    if (currentMonth == DateTime.january) {
      // If the current month is January, set the previous month to December of the previous year
      adjustedPreviousMonth = DateTime.december;
      adjustedPreviousYear = currentYear - 1;
    } else {
      // Otherwise, set the previous month to the last month and the year to the current year
      adjustedPreviousMonth = currentMonth - 1;
      adjustedPreviousYear = currentYear;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(currentYear, currentMonth,
          15), // Initial date is 15th of current month
      firstDate: DateTime(adjustedPreviousYear, adjustedPreviousMonth,
          1), // First selectable date is 1st of previous month
      lastDate: DateTime(currentYear, currentMonth,
          31), // Last selectable date is end of current month
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (date) =>
          date.year == currentYear &&
          (date.month == currentMonth || date.month == adjustedPreviousMonth),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedBillGenerationDate = selectedDate.day;
      });
    }
  }

  Future<void> _selectDueDate() async {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Set initial date to the 5th of the current month
    DateTime initialDate = DateTime(currentDate.year, currentDate.month, 5);

    // Set first date to 1st of the previous month
    DateTime firstDate = DateTime(currentDate.year, currentDate.month - 1, 1);

    // Set last date to the last date of the next month, handling the case of December
    DateTime lastDate;
    if (currentDate.month == DateTime.december) {
      lastDate = DateTime(currentDate.year + 1, 2, 0);
    } else {
      lastDate = DateTime(currentDate.year, currentDate.month + 2, 0);
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (date) => date.day >= 1 && date.day <= 31,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDueDate = selectedDate.day;
      });
    }
  }

  Widget _buildBillAndDueDateFields() {
    return Row(
      children: [
        Expanded(
          flex: 70,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                LongButton(
                  text: _selectedBillGenerationDate == null
                      ? 'Bill Date'
                      : 'Bill Date : ${_selectedBillGenerationDate}',
                  icon: const Icon(CupertinoIcons.calendar_today),
                  onPressed: _selectBillGenerationDate,
                ),
                const SizedBox(height: 8),
                LongButton(
                  text: _selectedDueDate == null
                      ? 'Due Date'
                      : 'Due Date : $_selectedDueDate',
                  icon: const Icon(CupertinoIcons.calendar_today),
                  onPressed: _selectDueDate,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 30,
          child: Center(
            child: MyIconButton(
              icon: Icon(
                CupertinoIcons.arrow_right,
                color: Theme.of(context).canvasColor,
              ),
              ontap: _submitCreditCardData, // Use the extracted function
            ),
          ),
        ),
      ],
    );
  }
}

  // ... other methods

