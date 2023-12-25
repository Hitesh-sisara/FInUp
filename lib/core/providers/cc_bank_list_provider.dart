import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cc_bank_list_provider.g.dart';

@riverpod
CCBankList ccBankList(_) => CCBankList();

class CCBankList {
  final _client = Supabase.instance.client;
  // Get Shared Preferences instance

  Future<List<String>> get_cc_banks_list() async {
    final _prefs = await SharedPreferences.getInstance();

    // Check for cached data
    final cachedData = _prefs.getStringList('cc_banks_list');

    final cachedTimestamp = _prefs.getInt('cc_banks_list_timestamp');

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
    final res = await _client.from('cc_banks_list').select('bank_name');

    if (res.isNotEmpty) {
      List<String> bankNames =
          res.map((e) => e['bank_name'] as String).toList();
      // Store fetched data in Shared Preferences with timestamp
      await _prefs.setStringList('cc_banks_list', bankNames);
      await _prefs.setInt(
          'cc_banks_list_timestamp', DateTime.now().millisecondsSinceEpoch);

      return bankNames;
    }

    return [];
  }
}
