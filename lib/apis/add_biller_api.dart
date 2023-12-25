import 'package:finup/models/creditCard_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_biller_api.g.dart';

@riverpod
AddBillerAPI addBillerAPI(_) => AddBillerAPI();

class AddBillerAPI {
  final _client = Supabase.instance.client;

  Future<List<CreditCard>> getCreditCards() async {
    final res =
        await _client.from('credit_cards').select(); // Select all columns

    if (res.isNotEmpty) {
      return res.map<CreditCard>((row) => CreditCard.fromJson(row)).toList();
    }

    return [];
  }

  Future<CreditCard?> addCreditCard(CreditCard creditCard) async {
    return await _client.from('credit_cards').insert(creditCard.toJson());
  }
}
