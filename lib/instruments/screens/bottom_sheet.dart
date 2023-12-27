import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/common/lists.dart';
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

  bool isLoading = false;

  final TextEditingController last4DigitsController = TextEditingController();
  final TextEditingController creditLimitController = TextEditingController();
  final TextEditingController nameOnCardController = TextEditingController();

  int? _selectedBillGenerationDate;
  int? _selectedDueDate;
  String? _selectedNetwork;

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
      setState(() => isLoading = true);
      try {
        final creditCard = CreditCard(
          id: '',
          userId: '',
          bank: selectedBank!,
          cardName: _selectedCreditCard!,
          last4Digits: int.parse(last4DigitsController.text.trim()),
          creditLimit: int.parse(creditLimitController.text),
          intBillDate: _selectedBillGenerationDate!,
          intDueDate: _selectedDueDate!,
          NameOnCard: nameOnCardController.text.trim(),
          Network: _selectedNetwork!,
        );

        await ref.read(billerAPIProvider).addCreditCard(creditCard);

        Navigator.of(context).pop();

        context.showAlert("Credit Card added succsessfully");
      } catch (error) {
        debugPrint('Error adding credit card: $error');
        await context.showAlertDialog(
          content: 'Failed to add credit card. Please try again.',
          defaultActionText: 'OK',
        );
      } finally {
        setState(() => isLoading = false);
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
      height: 450.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Position "Add a Credit Card" text at the top
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Icon(CupertinoIcons.creditcard),
                  ),
                  Text(
                    'Add Credit Card',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Center the remaining elements using a separate column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ... other input fields

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedBank == null) _bankSelector(),

                        // Show only if bank isn't selected

                        if (selectedBank != null &&
                                _selectedCreditCard == null ||
                            _selectedNetwork == null)
                          _bankAndCardSelector(),

                        if (_selectedCreditCard != null &&
                            !_isCardDeatiledFilled &&
                            _selectedNetwork != null)
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
          ],
        ),
      ),
    );
  }

  Widget _bankAndCardSelector() {
    return Column(
      children: [
        // Show only if bank isn't selected

        if (selectedBank != null && _selectedCreditCard == null)
          if (selectedBank!.isNotEmpty)
            Column(
              children: [
                _bankSelector(),
                SizedBox(height: 20.h),
                _creditCardSelector(),
              ],
            ),

        if (selectedBank != null && _selectedCreditCard != null)
          if (_selectedCreditCard!.isNotEmpty)
            Column(
              children: [
                _bankSelector(),
                SizedBox(height: 20.h),
                _creditCardSelector(),
                SizedBox(height: 20.h),
                _networkSelector(),
              ],
            ),
      ],
    );
  }

  Widget _bankSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bank Name',
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(height: 8.h),
          FutureBuilder<List<String>>(
            future: ref.read(ccBankListProvider).get_cc_banks_list(),
            builder: (context, snapshot) {
              print(snapshot.data);
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
          Text(
            'Card Name',
            style: TextStyle(fontSize: 20.sp),
          ),
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

  Widget _networkSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Network',
            style: TextStyle(fontSize: 20.sp),
          ),
          const SizedBox(height: 8),
          isLoadingCCList
              ? const CircularProgressIndicator()
              : FancyDropdownButton(
                  title: _selectedNetwork ?? 'Select Card Network',
                  items:
                      cardNetworks.map((network) => network['name']!).toList(),
                  value: _selectedNetwork, // Track the selected card
                  onChanged: (value) {
                    setState(() {
                      _selectedNetwork = value!; // Update selected card
                    });
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
                // Pinput(
                //   // Replace TextFormField with Pinput
                //   controller: last4DigitsController,
                //   length: 4,
                //   onChanged: (value) {
                //     // Handle input changes as needed
                //   },
                //   onCompleted: (value) {
                //     // Handle completion actions if required
                //   },
                // ),
                // const SizedBox(height: 16),
                TextFormField(
                  controller: last4DigitsController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Card\'s last 4 digit ',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the last 4 digits';
                    }
                    return null; // Validation passes
                  },
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 20.h),

                TextFormField(
                  controller:
                      nameOnCardController, // Use a dedicated controller for the name
                  keyboardType:
                      TextInputType.name, // Optimized keyboard for names
                  decoration: InputDecoration(
                    labelText: 'Name on card', // Clear label for user guidance
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the name on the card'; // Informative error message
                    }

                    // Optional validation for name formatting if required

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
              isLoading: isLoading,
              icon: Icon(
                CupertinoIcons.arrow_right,
                color: Theme.of(context).canvasColor,
              ),
              ontap: () async {
                isLoading
                    ? null
                    : {
                        await _submitCreditCardData(),
                      };
              }, // Use the extracted function
            ),
          ),
        ),
      ],
    );
  }
}

  // ... other methods

