import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyIconButton extends StatelessWidget {
  final Icon icon;
  final double size;
  final void Function() ontap;
  final bool isLoading; // Added `isLoading` property

  const MyIconButton({
    Key? key,
    required this.icon,
    this.size = 64,
    required this.ontap,
    this.isLoading = false, // Set default value for `isLoading`
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
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors
                    .white, // Customize progress indicator color if needed
              )
            : icon,
      ),
    );
  }
}
