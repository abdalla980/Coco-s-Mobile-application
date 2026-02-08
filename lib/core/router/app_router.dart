import 'package:go_router/go_router.dart';
import 'package:cocos_mobile_application/features/auth/login_screen.dart';
import 'package:cocos_mobile_application/features/auth/register_screen.dart';
import 'package:cocos_mobile_application/features/onboarding/splash_screen.dart';
import 'package:cocos_mobile_application/features/onboarding/welcome_page.dart';
import 'package:cocos_mobile_application/features/dashboard/home_screen.dart';
import 'package:cocos_mobile_application/features/settings/settings.dart';
import 'package:cocos_mobile_application/features/social/connect_social_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const welcome = '/welcome';
  static const home = '/home';
  static const settings = '/settings';
  static const connectSocial = '/social/connect';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const Welcomepage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Homescreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const Settings(),
    ),
    GoRoute(
      path: AppRoutes.connectSocial,
      builder: (context, state) => const ConnectSocialPage(),
    ),
  ],
);
