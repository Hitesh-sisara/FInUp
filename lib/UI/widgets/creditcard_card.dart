import 'package:finup/UI/billers/credit_card/add_sheet.dart';
import 'package:finup/UI/widgets/creditCrad_bill_details.dart';
import 'package:finup/models/creditCard_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreditCardCard extends StatelessWidget {
  final CreditCard creditCard;

  const CreditCardCard({Key? key, required this.creditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: 200.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
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
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
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
                        color: Theme.of(context).secondaryHeaderColor,
                        width: (1.sw - 32.w) / 2,
                        height: 200.h,

                        //add due date and bil data bill amount data here

                        child: CreditCardBillSection(creditCard: creditCard),

                        // color: Color(0xffF0F8FF),
                        // color: Color(0xff434f66),
                        // color: Theme.of(context).,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
          child: Row(
            children: [
              InkWell(
                onTap: () => showAddSheetCreditCard(context, creditCard.id),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(right: 4.w),
                    height: 70.h,
                    width: 70.w,
                    child: Icon(
                      CupertinoIcons.add,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(left: 4.w, right: 4.w),
                    height: 70.h,
                    width: 70.w,
                    child: Icon(
                      Icons.sell_outlined,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    child: Icon(
                      CupertinoIcons.arrow_up,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    child: Icon(
                      CupertinoIcons.arrow_down,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.only(left: 4.w),
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    child: Icon(
                      Icons.settings,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
