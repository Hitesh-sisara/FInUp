import 'package:finup/apis/auth_user.dart';
import 'package:finup/auth/screens/welcome_screen.dart';
import 'package:finup/common/widgets/error.dart';
import 'package:finup/common/widgets/loader.dart';
import 'package:finup/instruments/screens/new_instrument.dart';
import 'package:finup/navigation/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

@riverpod
RouterConfig<Object>? route(RouteRef _) => _routes;

final _routes = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            return ref.watch(authUserProvider).when(
                data: (user) {
                  return (user != null) ? MainWrapper() : const WelcomeScreen();
                },
                error: ((error, stackTrace) {
                  return ErrorPage(error: error.toString());
                }),
                loading: () => const LoadingPage());
          },
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainWrapper(),
    ),
    GoRoute(
      path: '/new-biller',
      builder: (context, state) => NewBiller(),
    ),
    // GoRoute(
    //   path: '/signin',
    //   builder: (context, state) => const SignInScreen(),
    // ),
    // GoRoute(
    //   path: '/signup',
    //   builder: (context, state) => const SignupScreen(),
    // ),
    // GoRoute(
    //   path: '/verify-email',
    //   builder: (context, state) {
    //     final params = state.extra as VrifyEmailParams?;

    //     if (params == null) {
    //       throw 'Missing `Email Params` object';
    //     }

    //     return VerifyEmail(params: params);
    //   },
    // ),
    // GoRoute(
    //   path: '/reset-password',
    //   builder: (context, state) {
    //     final params = state.extra as SendEmailParams?;

    //     return ResetPassword(params: params);
    //   },
    // ),
    // GoRoute(
    //   path: '/set-new-password',
    //   builder: (context, state) => const SetNewPassword(),
    // ),
  ],
);
