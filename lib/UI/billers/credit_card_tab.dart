import 'package:finup/UI/widgets/creditcard_card.dart';
import 'package:finup/apis/fetch_biller_api.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardsTab extends ConsumerWidget {
  const CreditCardsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final creditCards = ref.watch(fetchAllCreditCardProvider);

    return ref.watch(fetchAllCreditCardProvider).when(
          data: (List<CreditCard> creditCardList) {
            return ListView.builder(
              itemCount: creditCardList.length,
              itemBuilder: (context, index) {
                final creditCard = creditCardList[index];
                return CreditCardCard(creditCard: creditCard);
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error fetching credit cards : $error')),
        );
  }
}
