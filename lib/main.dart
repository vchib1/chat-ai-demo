import 'package:chatgpt_api_demo/src/providers/chat_provider.dart';
import 'package:chatgpt_api_demo/src/services/api_service.dart';
import 'package:chatgpt_api_demo/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider(api: API())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
