import 'package:go_router/go_router.dart';

import 'src/presentation/guards/auth_guard.dart';
import 'src/presentation/guards/guest_guard.dart';
import 'src/presentation/pages/account/profile_page.dart';
import 'src/presentation/pages/admin/admin_page.dart';
import 'src/presentation/pages/auth/forgot_password_page.dart';
import 'src/presentation/pages/auth/login_page.dart';
import 'src/presentation/pages/main_page.dart';
import 'src/presentation/pages/auth/register_page.dart';
import 'src/presentation/pages/web/home_page.dart';

bool _initialized = false;

late GoRouter _router;
GoRouter get router => _router;

void setupRouter([String initialRoute = '/login']) {
  if (_initialized) return;
  _router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
        redirect: guestGuard,
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterPage(),
        redirect: guestGuard,
      ),
      GoRoute(
        path: '/forgot',
        builder: (_, __) => const ForgotPasswordPage(),
        redirect: guestGuard,
      ),
      GoRoute(
        path: '/main',
        builder: (_, __) => const MainPage(),
        redirect: authGuard,
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminPage(),
        redirect: authGuard,
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfilePage(),
        redirect: authGuard,
      ),
    ],
  );
  _initialized = true;
}
