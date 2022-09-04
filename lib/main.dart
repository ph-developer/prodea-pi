import 'package:asuka/asuka.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'injection.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupInjection();
  Routes.setupRoutes();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRODEA',

      // Theme
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFA250),
        brightness: Brightness.light,
      ),

      // Notification / Asuka
      builder: Asuka.builder,

      // Navigation / Seafarer
      navigatorKey: Routes.seafarer.navigatorKey,
      onGenerateRoute: Routes.seafarer.generator(),
    );
  }
}
