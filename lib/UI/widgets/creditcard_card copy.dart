import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreditCardCard extends StatelessWidget {
  final CreditCard creditCard;

  const CreditCardCard({Key? key, required this.creditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/bank-short-logos/${creditCard.bank}.svg",
                  width: 30.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creditCard.bank,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      creditCard.cardName,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              '**** **** **** ${creditCard.last4Digits}',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ],
      ),

      // child: ListTile(
      //   contentPadding: EdgeInsets.all(16),
      //   leading: Icon(Icons.credit_card, size: 36),
      //   title: Text(
      //     creditCard.bank,
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      // subtitle: Text(
      //   '**** **** **** ${creditCard.last4Digits}',
      //   style: TextStyle(fontSize: 16),
      // ),
      //   trailing: Icon(Icons.more_vert),
      // ),
    );
  }
}
