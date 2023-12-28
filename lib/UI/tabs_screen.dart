import 'package:finup/UI/billers/credit_card/credit_card_tab.dart';
import 'package:finup/apis/fetch_biller_api.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Tab(text: 'Credit Cards'),
                Tab(text: 'Utilities'),
                Tab(text: 'Loans'),
                Tab(text: 'Subscriptions'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            CreditCardsTab(),
            CreditCardsTab(),
            CreditCardsTab(),
            CreditCardsTab(),
          ],
        ),
      ),
    );
  }
}

class CreditCardCard extends StatelessWidget {
  final CreditCard creditCard;

  const CreditCardCard({Key? key, required this.creditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(Icons.credit_card, size: 36),
        title: Text(
          creditCard.bank,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '**** **** **** ${creditCard.last4Digits}',
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
