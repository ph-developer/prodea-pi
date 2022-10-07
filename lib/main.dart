import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'router.dart';
import 'src/presentation/controllers/auth_controller.dart';
import 'src/presentation/controllers/connection_state_controller.dart';
import 'src/presentation/stores/cities_store.dart';
import 'src/presentation/stores/users_store.dart';
import 'src/presentation/widgets/app_widget.dart';
import 'firebase_options.dart';
import 'injector.dart';
import 'src/presentation/widgets/boot_widget.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(BootWidget(widgetsBinding: widgetsBinding));

  await Future.delayed(const Duration(seconds: 1));

  if (!kIsWeb) FlutterNativeSplash.remove();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupInjector();

  final AuthController authController = inject();
  final ConnectionStateController connectionStateController = inject();
  final CitiesStore citiesStore = inject();
  final UsersStore usersStore = inject();

  await Future.wait([
    authController.fetchCurrentUser(),
    connectionStateController.fetchConnectionStatus(),
    citiesStore.fetchCities(),
    usersStore.fetchUsers(),
  ]);

  if (kIsWeb && Uri.base.toString().endsWith('/#/')) {
    setupRouter('/');
  } else if (authController.isLoggedIn) {
    setupRouter('/main');
  } else {
    setupRouter('/login');
  }

  await Future.delayed(const Duration(seconds: 1));

  runApp(const AppWidget());
}
