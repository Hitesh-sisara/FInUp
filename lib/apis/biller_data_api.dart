import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'biller_data_api.g.dart';

@riverpod
BillerDataAPI billerDataAPI(_) => BillerDataAPI();

class BillerDataAPI {
  final _client = Supabase.instance.client;

  Future<List<String>> get_cc_banks_list() async {
    final res = await _client.from('cc_banks_list').select('bank_name');

    if (res.isNotEmpty) {
      return res.map<String>((e) => e['name'].toString()).toList();
    }

    return [];
  }
}
