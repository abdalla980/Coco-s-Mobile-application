import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Service for handling Facebook/Instagram OAuth authentication
class FacebookAuthService {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  /// Authenticate user with Facebook Login and request Instagram permissions
  /// Returns access token on success, null on failure/cancellation
  Future<String?> loginWithInstagramPermissions() async {
    try {
      // Request Facebook Login with Instagram Content Publishing permissions
      final LoginResult result = await _facebookAuth.login(
        permissions: [
          'instagram_basic',
          'instagram_content_publish',
          'instagram_business_basic',
          'instagram_business_content_publish',
          'pages_read_engagement',
        ],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        return accessToken?.tokenString;
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint('Facebook login cancelled by user');
        return null;
      } else {
        debugPrint('Facebook login failed: ${result.message}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during Facebook login: $e');
      return null;
    }
  }

  /// Authenticate user with Facebook Login and request Facebook Page permissions
  /// Returns access token on success, null on failure/cancellation
  Future<String?> loginWithFacebookPermissions() async {
    try {
      final LoginResult result = await _facebookAuth.login(
        permissions: [
          'pages_show_list',
          'pages_read_engagement',
          'pages_manage_posts',
        ],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        return accessToken?.tokenString;
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint('Facebook login cancelled by user');
        return null;
      } else {
        debugPrint('Facebook login failed: ${result.message}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during Facebook login: $e');
      return null;
    }
  }

  /// Get current access token if user is already logged in
  Future<String?> getCurrentAccessToken() async {
    try {
      final AccessToken? accessToken = await _facebookAuth.accessToken;
      return accessToken?.tokenString;
    } catch (e) {
      debugPrint('Error getting current access token: $e');
      return null;
    }
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    final token = await getCurrentAccessToken();
    return token != null;
  }

  /// Log out user from Facebook/Instagram
  Future<void> logout() async {
    try {
      await _facebookAuth.logOut();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  /// Get user profile information
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userData = await _facebookAuth.getUserData(
        fields: 'id,name,email,picture',
      );
      return userData;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }
}
