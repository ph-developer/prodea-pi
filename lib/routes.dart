import 'package:prodea/pages/admin_page.dart';
import 'package:prodea/pages/boot_page.dart';
import 'package:prodea/pages/home_page.dart';
import 'package:prodea/pages/login_page.dart';
import 'package:prodea/pages/profile_page.dart';
import 'package:seafarer/seafarer.dart';

abstract class Routes {
  static final seafarer = Seafarer();

  static void setupRoutes() {
    seafarer.addRoutes([
      SeafarerRoute(
        name: '/',
        builder: (_, __, ___) => const BootPage(),
      ),
      SeafarerRoute(
        name: '/login',
        builder: (_, __, ___) => const LoginPage(),
      ),
      SeafarerRoute(
        name: '/home',
        builder: (_, __, ___) => const HomePage(),
      ),
      SeafarerRoute(
        name: '/admin',
        builder: (_, __, ___) => const AdminPage(),
      ),
      SeafarerRoute(
        name: '/profile',
        builder: (_, __, ___) => const ProfilePage(),
      ),
    ]);
  }
}
