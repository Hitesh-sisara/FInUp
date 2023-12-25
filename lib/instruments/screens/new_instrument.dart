import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewBiller extends StatefulWidget {
  @override
  _NewBillerState createState() => _NewBillerState();
}

class _NewBillerState extends State<NewBiller> {
  String selectedInstrumentType = 'CreditCard';
  String selectedInstrumentTypes = '';

  String selectedBank = '';
  String selectedCreditCard = '';

  List<String> instrumentTypes = ["CreditCard", "Insurance", "Loan", "Utility"];
  List<String> instrumentTypess = [];

  List<String> banksList = [];
  List<String> creditCardList = [];

  final TextEditingController last4DigitsController = TextEditingController();
  final TextEditingController cardIdentifierController =
      TextEditingController();
  final TextEditingController creditLimitController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch instrument types on initialization
    fetchInstrumentTypes();
  }

  Future<void> fetchInstrumentTypes() async {
    // Replace 'cities' and 'name' with your Supabase table and column names
    final data =
        await Supabase.instance.client.from('instrument_list').select("name");

    print(data);
    if (data.isNotEmpty) {
      print(data.toList());
      setState(() {
        // Update instrument types
        // Assuming data['data'] is a List<Map<String, dynamic>>
        List<String> instrumentTypess =
            data.map<String>((e) => e['name'].toString()).toList();
        // Set the first instrument type as default
        selectedInstrumentTypes =
            instrumentTypess.isNotEmpty ? instrumentTypess.first : '';

        // Print or use the instrument types in a way that suits your needs
        print('Instrument Types: $instrumentTypess');
        print(instrumentTypess.last);
        print(selectedInstrumentTypes);
      });
    }
  }

  Future<void> fetchBanks() async {
    // Fetch banks based on the selected instrument type
    final data = await Supabase.instance.client
        .from('cc_banks_list')
        .select('bank_name');

    print(data);

    if (data.isNotEmpty) {
      setState(() {
        banksList = data.map<String>((e) => e['bank_name'].toString()).toList();
        // Set the first bank as default
        selectedBank = banksList.isNotEmpty ? banksList.first : '';

        // selectedbankTypess =
        //     instrumentTypess.isNotEmpty ? instrumentTypess.first : '';

        print('Banks List: $banksList');
      });
    }
  }

  Future<void> fetchCreditCards() async {
    // Fetch credit cards based on the selected bank
    final data = await Supabase.instance.client
        .from('cc_list')
        .select('card_name')
        .eq('bank', selectedBank);

    print(data);

    if (data.isNotEmpty) {
      setState(() {
        creditCardList =
            data.map<String>((e) => e['card_name'].toString()).toList();

        print('cc List: $creditCardList');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new Biller'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedInstrumentType,
              onChanged: (String? value) {
                setState(() {
                  selectedInstrumentType = value!;
                  // Fetch banks for the selected instrument type
                  fetchBanks();
                });
              },
              items:
                  instrumentTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Instrument Type'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedBank,
              onChanged: (String? value) {
                setState(() {
                  selectedBank = value!;
                  // Fetch credit cards for the selected bank
                  fetchCreditCards();
                });
              },
              items: banksList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Bank'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedCreditCard,
              onChanged: (String? value) {
                setState(() {
                  selectedCreditCard = value!;
                });
              },
              items:
                  creditCardList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Credit Card'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: last4DigitsController,
              decoration: InputDecoration(labelText: 'Last 4 Digits of Card'),
            ),
            TextFormField(
              controller: cardIdentifierController,
              decoration: InputDecoration(labelText: 'Card Identifier'),
            ),
            TextFormField(
              controller: creditLimitController,
              decoration: InputDecoration(labelText: 'Credit Limit'),
            ),
            TextFormField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
            ),
          ],
        ),
      ),
    );
  }
}
