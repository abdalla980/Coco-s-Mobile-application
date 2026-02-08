import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cocos_mobile_application/core/di/service_locator.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return getIt<AuthService>();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userDataProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  return ref.watch(authServiceProvider).getUserDataStream();
});
