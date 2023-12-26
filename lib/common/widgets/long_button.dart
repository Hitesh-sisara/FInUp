import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LongButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final void Function()? onPressed;
  final Color? colour;
  final bool isLoading;

  const LongButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.colour,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colour ??
            Theme.of(context)
                .primaryColor, // Use colour or default to theme's primary color

        disabledForegroundColor:
            Colors.grey, // Set disabled text color to white

        // backgroundColor: colour ?? Colors.yellow[900],
        foregroundColor: Theme.of(context).colorScheme.background,
        // disabledForegroundColor: Colors.white,
        minimumSize: Size(1.sw / 1.2, 60.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 30.w,
              height: 30.h,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                SizedBox(width: 16.w),
                Text(text),
              ],
            ),
    );
  }
}
