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
      child: SizedBox(
        height: 200.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: (1.sw - 32.w) / 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creditCard.cardName,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/card-networks/${creditCard.Network}.svg",
                                width: 40.w,
                                fit: BoxFit.contain,
                                // Use a ColorFilter for efficient color adaptation:
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : null, // Use default color in light mode
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Text(
                                  '**** ${creditCard.last4Digits}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          SvgPicture.asset(
                            "assets/svgs/bank-short-logos/${creditCard.bank}.svg",
                            height: 40.h,
                            fit: BoxFit.contain,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              creditCard.NameOnCard,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xff212121),
                    width: (1.sw - 32.w) / 2,
                    height: 200.h,
                  )
                  // SvgPicture.asset(
                  //   "assets/svgs/bank-short-logos/${creditCard.bank}.svg",
                  //   height: 40.h,
                  //   fit: BoxFit.contain,
                  // ),
                  // SizedBox(
                  //   width: 20.w,
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  // Text(
                  //   creditCard.bank,
                  //   style: TextStyle(
                  //       fontSize: 18.sp, fontWeight: FontWeight.bold),
                  // ),
                  //     Text(
                  //       creditCard.cardName,
                  //       style: TextStyle(
                  //           fontSize: 18.sp, fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
            // child: Text(
            //   '**** **** **** ${creditCard.last4Digits}',
            //   style: TextStyle(fontSize: 25),
            // ),
            // ),
          ],
        ),
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
