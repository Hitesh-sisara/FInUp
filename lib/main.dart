import 'package:finup/core/credentials.dart';
import 'package:finup/core/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: SupabaseConstants.SUPABASE_URL,
    anonKey: SupabaseConstants.supabase_public_api_key,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.read(routeProvider);
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp.router(
        title: 'Menu Master',
        theme: FlexThemeData.light(
            scheme: FlexScheme.blue, textTheme: GoogleFonts.poppinsTextTheme()),
        darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.blue, textTheme: GoogleFonts.poppinsTextTheme()),
        themeMode: ThemeMode.system,
        routerConfig: routes,
      ),
    );
  }
}
