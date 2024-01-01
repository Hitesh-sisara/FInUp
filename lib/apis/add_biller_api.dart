import 'package:finup/models/bill_model.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_biller_api.g.dart';

@riverpod
BillerAPI billerAPI(_) => BillerAPI();

class BillerAPI {
  final _client = Supabase.instance.client;

  Future<List<CreditCard>> getCreditCards() async {
    final res = await _client.from('credit_cards').select();

    print(res);

    if (res.isNotEmpty) {
      return res.map<CreditCard>((row) => CreditCard.fromJson(row)).toList();
    }

    return [];
  }

  Future<void> addCreditCard(CreditCard creditCard) async {
    return await _client.from('credit_cards').insert(creditCard.toJson());
  }

  Future<void> addNewBill(Bill bill) async {
    print(bill.toJson());
    return await _client.from('bill').insert(bill.toJson());
  }

  Future<Map<String, dynamic>?> findLatestBill(String accountId) async {
    final res = await _client
        .from('bill')
        .select('*')
        .eq('account', accountId)
        .order('created_at', ascending: false)
        .limit(1)
        .single();

    print(res);
  }
}
