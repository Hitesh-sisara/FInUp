import 'package:finup/apis/add_biller_api.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_biller_api.g.dart';

@riverpod
Future<List<CreditCard>> fetchAllCreditCard(
    AutoDisposeFutureProviderRef<List<CreditCard>> ref) {
  return ref.watch(billerAPIProvider).getCreditCards();
}
