import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyIconButton extends StatelessWidget {
  final Icon icon;
  final double size;
  final void Function() ontap;

  const MyIconButton({
    Key? key,
    required this.icon,
    this.size = 64,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: size.sp,
        width: size.sp,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        child: icon,
      ),
    );
  }
}
