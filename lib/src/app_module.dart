import 'package:flutter_modular/flutter_modular.dart';

import 'presentation/guards/auth_guard.dart';
import 'presentation/guards/guest_guard.dart';
import 'presentation/pages/account/profile_page.dart';
import 'presentation/pages/admin/admin_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/web/home_page.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const HomePage(),
        ),
        ChildRoute(
          '/login',
          child: (_, __) => const LoginPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/register',
          child: (_, __) => const RegisterPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/forgot',
          child: (_, __) => const ForgotPasswordPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/main',
          child: (_, __) => const MainPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/admin',
          child: (_, __) => const AdminPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/profile',
          child: (_, __) => const ProfilePage(),
          guards: [AuthGuard()],
        ),
      ];
}
