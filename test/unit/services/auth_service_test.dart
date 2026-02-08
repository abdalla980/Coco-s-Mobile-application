import 'package:flutter_test/flutter_test.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('currentUser returns null when not logged in', () {
      expect(authService.currentUser, isNull);
    });

    test('authStateChanges returns a stream', () {
      expect(authService.authStateChanges, isA<Stream>());
    });

    test('getUserDataStream returns a stream', () {
      expect(authService.getUserDataStream(), isA<Stream>());
    });
  });
}
