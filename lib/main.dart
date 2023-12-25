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
        // theme: FlexThemeData.light(
        //     bottomAppBarElevation: 2,
        //     scheme: FlexScheme.blue,
        //     textTheme: GoogleFonts.poppinsTextTheme()),
        // darkTheme: FlexThemeData.dark(
        //     bottomAppBarElevation: 2,
        //     scheme: FlexScheme.blue,
        //     textTheme: GoogleFonts.poppinsTextTheme()),

        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        //   useMaterial3: true,
        // ),

        theme: FlexThemeData.light(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        themeMode: ThemeMode.system,
        routerConfig: routes,
      ),
    );
  }
}
