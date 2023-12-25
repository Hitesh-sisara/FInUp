// Future<void> fetchAndCacheDataForBank(String bankName) async {
//   final prefs = await SharedPreferences.getInstance();
//   final cachedCards = prefs.getStringList('${bankName}_creditCards');

//   if (cachedCards == null) {
//     // Fetch cards for this bank from database
//     final cardsData = await Supabase.instance.client
//         .from('cc_list')
//         .select('card_name')
//         .eq('bank', bankName);

//     // Store fetched cards in shared preferences
//     await prefs.setStringList('${bankName}_creditCards',
//         cardsData.map((e) => e['card_name'].toString()).toList());
//   } else {
//     // Retrieve cached cards
//     creditCardList = cachedCards;
//   }
// }



// import 'package:finup/apis/biller_data_api.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'cc_banks_list.g.dart';

// @riverpod
// CC_banks_Data memoryRepository(WidgetRef ref) => CC_banks_Data(ref: ref);

// class CC_banks_Data {
//   final WidgetRef ref;
//   CC_banks_Data({
//     required this.ref,
//   });


//   Future<List<String>> cachedBankList() async {
//         final prefs = await SharedPreferences.getInstance();

//           final cachedCCBanks = prefs.getStringList('ccBanksList');


//           if(cachedCCBanks == null) {
//             final list = await ref.read(billerDataAPIProvider).get_cc_banks_list();


//              if (list.isNotEmpty) {

//               prefs.setStringList(key, value) = list;
//     }
//           }



   

//     return [];
//   }
// }
