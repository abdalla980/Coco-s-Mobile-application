import 'package:cocos_mobile_application/HomeScreen.dart';
import 'package:cocos_mobile_application/auth_service.dart';
import 'package:cocos_mobile_application/login_screen.dart';
import 'package:cocos_mobile_application/splash_screen.dart';
import 'package:cocos_mobile_application/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cocos_mobile_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cocos App',
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.active) {
            final user = authSnapshot.data;

            if (user == null) {
              // User is not logged in
              return const LoginScreen();
            }

            // User is logged in, check if they completed questions
            return StreamBuilder<Map<String, dynamic>?>(
              stream: authService.getUserDataStream(),
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                    ConnectionState.active) {
                  final userData = userDataSnapshot.data;
                  final questionsCompleted =
                      userData?['questionsCompleted'] ?? false;

                  if (questionsCompleted) {
                    // Questions completed, go to main app
                    return const Homescreen();
                  } else {
                    // Questions not completed, show welcome page
                    return const Welcomepage();
                  }
                }
                // While waiting for user data, show splash
                return const SplashScreen();
              },
            );
          }
          // While waiting for auth state, show Splash Screen
          return const SplashScreen();
        },
      ),
    );
  }
}
