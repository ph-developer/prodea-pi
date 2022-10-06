import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'injector.dart';
import 'router.dart';
import 'src/presentation/controllers/auth_controller.dart';
import 'src/presentation/controllers/connection_state_controller.dart';
import 'src/presentation/stores/cities_store.dart';
import 'src/presentation/stores/users_store.dart';
import 'src/presentation/widgets/app_widget.dart';
import 'src/presentation/widgets/boot_widget.dart';

Future<void> main([args, bool test = false]) async {
  if (!test) runApp(const BootWidget());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupInjector();

  final AuthController authController = inject();
  final ConnectionStateController connectionStateController = inject();
  final CitiesStore citiesStore = inject();
  final UsersStore usersStore = inject();

  await authController.fetchCurrentUser();

  connectionStateController.fetchConnectionStatus();
  citiesStore.fetchCities();
  usersStore.fetchUsers();

  if (kIsWeb && Uri.base.toString().endsWith('/#/')) {
    setupRouter('/');
  } else if (authController.isLoggedIn) {
    setupRouter('/main');
  } else {
    setupRouter('/login');
  }

  runApp(const AppWidget());
}
