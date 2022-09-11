import 'package:prodea/pages/admin/admin_page.dart';
import 'package:prodea/pages/auth/forgot_password_page.dart';
import 'package:prodea/pages/boot_page.dart';
import 'package:prodea/pages/main_page.dart';
import 'package:prodea/pages/auth/login_page.dart';
import 'package:prodea/pages/account/profile_page.dart';
import 'package:prodea/pages/auth/register_page.dart';
import 'package:prodea/pages/status/denied_page.dart';
import 'package:prodea/pages/status/waiting_page.dart';
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
        name: '/register',
        builder: (_, __, ___) => const RegisterPage(),
      ),
      SeafarerRoute(
        name: '/forgot-password',
        builder: (_, __, ___) => const ForgotPasswordPage(),
      ),
      SeafarerRoute(
        name: '/main',
        builder: (_, __, params) {
          final pageIndex = params.param<int>('pageIndex');
          return MainPage(
            pageIndex: pageIndex,
          );
        },
        params: [
          SeafarerParam<int>(name: 'pageIndex', defaultValue: 0),
        ],
      ),
      SeafarerRoute(
        name: '/admin',
        builder: (_, __, ___) => const AdminPage(),
      ),
      SeafarerRoute(
        name: '/profile',
        builder: (_, __, ___) => const ProfilePage(),
      ),
      SeafarerRoute(
        name: '/denied',
        builder: (_, __, ___) => const DeniedPage(),
      ),
      SeafarerRoute(
        name: '/waiting',
        builder: (_, __, ___) => const WaitingPage(),
      ),
    ]);
  }
}
