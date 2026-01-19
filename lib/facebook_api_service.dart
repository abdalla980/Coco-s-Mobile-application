import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for Facebook Graph API operations
class FacebookApiService {
  static const String _baseUrl = 'https://graph.facebook.com/v18.0';

  /// Post a photo to a Facebook Page
  ///
  /// [pageId] - Facebook Page ID
  /// [imageUrl] - Publicly accessible URL of the image (REQUIRED)
  /// [message] - Post message/caption
  /// [pageAccessToken] - Page access token
  ///
  /// Returns Post ID on success, null on failure
  Future<String?> postPhoto({
    required String pageId,
    required String imageUrl,
    required String message,
    required String pageAccessToken,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$pageId/photos');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'url': imageUrl,
          'message': message,
          'access_token': pageAccessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id'] as String?;
      } else {
        debugPrint(
          'Facebook photo post failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error posting to Facebook: $e');
      return null;
    }
  }

  /// Get list of Facebook Pages the user manages
  /// Returns list of {id, name, access_token}
  Future<List<Map<String, dynamic>>> getUserPages({
    required String userAccessToken,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/me/accounts'
        '?fields=id,name,access_token'
        '&access_token=$userAccessToken',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['data'] as List<dynamic>?;
        return pages?.cast<Map<String, dynamic>>() ?? [];
      } else {
        debugPrint('Failed to get pages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting user pages: $e');
      return [];
    }
  }

  /// Get Page access token for a specific page
  /// This is needed because posting to pages requires page access token, not user token
  Future<String?> getPageAccessToken({
    required String pageId,
    required String userAccessToken,
  }) async {
    try {
      final pages = await getUserPages(userAccessToken: userAccessToken);

      for (final page in pages) {
        if (page['id'] == pageId) {
          return page['access_token'] as String?;
        }
      }

      debugPrint('Page not found in user\'s pages');
      return null;
    } catch (e) {
      debugPrint('Error getting page access token: $e');
      return null;
    }
  }
}
