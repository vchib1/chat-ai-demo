import 'package:chatgpt_api_demo/src/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
  /*runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MyApp()),
    ),
  );*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Chat AI Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: 96.dp,
                fontWeight: FontWeight.w300,
                letterSpacing: -1.5),
            displayMedium: TextStyle(
                fontSize: 60.dp,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.5),
            displaySmall:
                TextStyle(fontSize: 48.dp, fontWeight: FontWeight.w400),
            headlineMedium: TextStyle(
                fontSize: 34.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25),
            headlineSmall:
                TextStyle(fontSize: 24.dp, fontWeight: FontWeight.w400),
            titleLarge: TextStyle(
              fontSize: 20.dp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
            titleMedium: TextStyle(
                fontSize: 16.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15),
            titleSmall: TextStyle(
                fontSize: 14.dp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1),
            bodyLarge: TextStyle(
                fontSize: 16.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
            bodyMedium: TextStyle(
                fontSize: 14.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25),
            labelLarge: TextStyle(
                fontSize: 14.dp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.25),
            bodySmall: TextStyle(
                fontSize: 12.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4),
            labelSmall: TextStyle(
                fontSize: 10.dp,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5),
          ),
        ),
        home: const HomePage(),
      );
    });
  }
}
