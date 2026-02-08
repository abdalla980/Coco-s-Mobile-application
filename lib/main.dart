import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cocos_mobile_application/firebase_options.dart';
import 'package:cocos_mobile_application/config/env_config.dart';
import 'package:cocos_mobile_application/core/di/service_locator.dart';
import 'package:cocos_mobile_application/core/providers/providers.dart';
import 'package:cocos_mobile_application/features/auth/login_screen.dart';
import 'package:cocos_mobile_application/features/onboarding/splash_screen.dart';
import 'package:cocos_mobile_application/features/onboarding/welcome_page.dart';
import 'package:cocos_mobile_application/features/dashboard/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  if (kDebugMode && Platform.isAndroid) {
    debugPrint(
      'To get Android key hash for Facebook: keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64',
    );
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cocos App',
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          }
          return _UserDataHandler();
        },
        loading: () => const SplashScreen(),
        error: (_, __) => const LoginScreen(),
      ),
    );
  }
}

class _UserDataHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    return userData.when(
      data: (data) {
        final questionsCompleted = data?['questionsCompleted'] ?? false;
        if (questionsCompleted) {
          return const Homescreen();
        }
        return const Welcomepage();
      },
      loading: () => const SplashScreen(),
      error: (_, __) => const Welcomepage(),
    );
  }
}
