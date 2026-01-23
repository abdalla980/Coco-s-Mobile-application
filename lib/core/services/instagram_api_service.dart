import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for Instagram Graph API operations
class InstagramApiService {
  static const String _baseUrl = 'https://graph.instagram.com';

  /// Post a photo to Instagram (2-step process)
  /// Step 1: Create media container
  /// Step 2: Publish the container
  ///
  /// [igUserId] - Instagram Business Account ID
  /// [imageUrl] - Publicly accessible URL of the image (REQUIRED)
  /// [caption] - Post caption
  /// [accessToken] - Instagram User access token
  ///
  /// Returns Post ID on success, null on failure
  Future<String?> postPhoto({
    required String igUserId,
    required String imageUrl,
    required String caption,
    required String accessToken,
  }) async {
    try {
      // Step 1: Create media container
      final containerId = await _createMediaContainer(
        igUserId: igUserId,
        imageUrl: imageUrl,
        caption: caption,
        accessToken: accessToken,
      );

      if (containerId == null) {
        debugPrint('Failed to create media container');
        return null;
      }

      // Step 2: Publish the container
      final postId = await _publishContainer(
        igUserId: igUserId,
        containerId: containerId,
        accessToken: accessToken,
      );

      return postId;
    } catch (e) {
      debugPrint('Error posting to Instagram: $e');
      return null;
    }
  }

  /// Step 1: Create media container
  Future<String?> _createMediaContainer({
    required String igUserId,
    required String imageUrl,
    required String caption,
    required String accessToken,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$igUserId/media');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'image_url': imageUrl,
          'caption': caption,
          'access_token': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id'] as String?;
      } else {
        debugPrint(
          'Container creation failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error creating media container: $e');
      return null;
    }
  }

  /// Step 2: Publish media container
  Future<String?> _publishContainer({
    required String igUserId,
    required String containerId,
    required String accessToken,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$igUserId/media_publish');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'creation_id': containerId,
          'access_token': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id'] as String?;
      } else {
        debugPrint(
          'Publishing failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error publishing container: $e');
      return null;
    }
  }

  /// Get Instagram Business Account ID from access token
  /// This is needed to make API calls
  Future<String?> getInstagramBusinessAccountId({
    required String facebookPageId,
    required String accessToken,
  }) async {
    try {
      final uri = Uri.parse(
        'https://graph.facebook.com/v18.0/$facebookPageId'
        '?fields=instagram_business_account'
        '&access_token=$accessToken',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['instagram_business_account']?['id'] as String?;
      } else {
        debugPrint(
          'Failed to get IG account ID: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error getting Instagram account ID: $e');
      return null;
    }
  }

  /// Check posting rate limit status
  Future<Map<String, dynamic>?> getPublishingLimit({
    required String igUserId,
    required String accessToken,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/$igUserId/content_publishing_limit'
        '?access_token=$accessToken',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']?[0] as Map<String, dynamic>?;
      } else {
        debugPrint('Failed to get rate limit: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting publishing limit: $e');
      return null;
    }
  }
}
