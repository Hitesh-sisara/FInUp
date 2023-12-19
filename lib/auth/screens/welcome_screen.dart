import 'package:finup/apis/auth_api.dart';
import 'package:finup/common/widgets/long_button.dart';
import 'package:finup/common/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isGoogleSubmitting = false;

  Future<void> _googleSignIn() async {
    try {
      setState(() {
        _isGoogleSubmitting = true;
      });

      await ref.read(authAPIProvider).googleSignIn();

      _isGoogleSubmitting = false;

      if (mounted) {
        context.push("/home");
      }
    } catch (e) {
      setState(() {
        _isGoogleSubmitting = false;
      });

      print(e.toString());

      context.showAlert(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 25.h),
                  SvgPicture.asset(
                    "assets/svgs/Finup-logo-blue.svg",
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 60.h),
                  SvgPicture.asset(
                    "assets/svgs/welcome.svg",
                    height: 250.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Welcome",
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.h),
                    child: Text(
                      "Let's manage your expenses, bills, credit cards, loans, and subscriptions in a better way ",
                      style: TextStyle(fontSize: 20.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  LongButton(
                    isLoading: _isGoogleSubmitting,
                    text: "Continue With Google",
                    onPressed: _isGoogleSubmitting ? null : _googleSignIn,
                    icon: SvgPicture.asset(
                      "assets/svgs/google.svg",
                      height: 40.h,
                      width: 40.h,
                    ),
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
