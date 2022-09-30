import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'firebase_options.dart';
import 'src/app_module.dart';
import 'src/presentation/widgets/app_widget.dart';

Future<void> main([List<String> args = const [], Module? appModule]) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ModularApp(
      module: appModule ?? AppModule(),
      child: const AppWidget(),
    ),
  );
}
