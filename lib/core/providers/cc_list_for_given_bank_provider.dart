import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cc_list_for_given_bank_provider.g.dart';

// Provider for fetching credit card lists
@riverpod
CCListForBank ccListForBank(_) => CCListForBank();

class CCListForBank {
  final _client = Supabase.instance.client;

  Future<List<String>> getCCList(String bankName) async {
    final _prefs = await SharedPreferences.getInstance();
    // Check for cached data
    final cachedData = _prefs.getStringList('cc_list_$bankName');
    final cachedTimestamp = _prefs.getInt('cc_list_timestamp_$bankName');

    if (cachedData != null && cachedTimestamp != null) {
      DateTime now = DateTime.now();
      DateTime cachedDate =
          DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);

      // If cached data is not older than 1 month, return it
      if (now.difference(cachedDate) < Duration(days: 30)) {
        return cachedData;
      }
    }

    // Fetch data from Supabase if cache is invalid or missing
    final res =
        await _client.from('cc_list').select('card_name').eq('bank', bankName);

    if (res.isNotEmpty) {
      List<String> cardNames =
          res.map((e) => e['card_name'] as String).toList();

      // Store fetched data in Shared Preferences with timestamp
      await _prefs.setStringList('cc_list_$bankName', cardNames);
      await _prefs.setInt(
          'cc_list_timestamp_$bankName', DateTime.now().millisecondsSinceEpoch);

      return cardNames;
    } else {
      return [];
    }
  }
}
