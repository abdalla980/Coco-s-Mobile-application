import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cocos_mobile_application/config/env_config.dart';
import 'package:cocos_mobile_application/facebook_auth_service.dart';
import 'package:cocos_mobile_application/instagram_api_service.dart';
import 'package:cocos_mobile_application/facebook_api_service.dart';

class SocialConnectionService {
  // Keys for SharedPreferences
  static const String _instagramKey = 'instagram_connection';
  static const String _facebookKey = 'facebook_connection';

  // Services for real API integration
  final FacebookAuthService _authService = FacebookAuthService();
  final InstagramApiService _instagramService = InstagramApiService();
  final FacebookApiService _facebookService = FacebookApiService();

  // Connect Instagram - uses real API if enabled, otherwise mock
  Future<bool> connectInstagram(BuildContext context) async {
    if (EnvConfig.enableRealInstagram) {
      return await _connectInstagramReal(context);
    } else {
      return await _connectInstagramMock(context);
    }
  }

  // Real Instagram OAuth connection
  Future<bool> _connectInstagramReal(BuildContext context) async {
    try {
      // Perform Facebook OAuth with Instagram permissions
      final accessToken = await _authService.loginWithInstagramPermissions();

      if (accessToken == null) {
        return false; // User cancelled or error occurred
      }

      // Get user profile
      final profile = await _authService.getUserProfile();

      // Store connection data
      final prefs = await SharedPreferences.getInstance();
      final connectionData = {
        'username': profile?['name'] ?? 'Instagram User',
        'accountType': 'Business', // Real API only works with Business/Creator
        'connectedAt': DateTime.now().toIso8601String(),
        'profilePic': profile?['picture']?['data']?['url'] ?? '',
        'accessToken': accessToken,
        'isRealConnection': true,
      };
      await prefs.setString(_instagramKey, json.encode(connectionData));
      return true;
    } catch (e) {
      debugPrint('Error connecting Instagram (real): $e');
      return false;
    }
  }

  // Mock Instagram OAuth connection (existing implementation)
  Future<bool> _connectInstagramMock(BuildContext context) async {
    // Show mock login dialog
    final credentials = await _showMockLoginDialog(context, 'Instagram');
    if (credentials == null) return false;

    // Show account type selection
    final accountType = await _showAccountTypeDialog(context);
    if (accountType == null) return false;

    // If personal account, show warning
    if (accountType == 'Personal') {
      await _showPersonalAccountWarning(context);
      return false;
    }

    // Store connection data
    final prefs = await SharedPreferences.getInstance();
    final connectionData = {
      'username': credentials['username'],
      'accountType': accountType,
      'connectedAt': DateTime.now().toIso8601String(),
      'profilePic': 'https://via.placeholder.com/100', // Mock profile pic
      'isRealConnection': false,
    };
    await prefs.setString(_instagramKey, json.encode(connectionData));
    return true;
  }

  // Connect Facebook - uses real API if enabled, otherwise mock
  Future<bool> connectFacebook(BuildContext context) async {
    if (EnvConfig.enableRealFacebook) {
      return await _connectFacebookReal(context);
    } else {
      return await _connectFacebookMock(context);
    }
  }

  // Real Facebook OAuth connection
  Future<bool> _connectFacebookReal(BuildContext context) async {
    try {
      // Perform Facebook OAuth with Page permissions
      final accessToken = await _authService.loginWithFacebookPermissions();

      if (accessToken == null) {
        return false; // User cancelled or error occurred
      }

      // Get user's Facebook Pages
      final pages = await _facebookService.getUserPages(
        userAccessToken: accessToken,
      );

      if (pages.isEmpty) {
        // No pages found - show error
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('No Facebook Pages'),
              content: Text(
                'You need to have at least one Facebook Page to post content.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        return false;
      }

      // Show page selection dialog
      final selectedPage = await _showRealPageSelectionDialog(context, pages);
      if (selectedPage == null) return false;

      // Store connection data
      final prefs = await SharedPreferences.getInstance();
      final connectionData = {
        'username': selectedPage['name'],
        'pageName': selectedPage['name'],
        'pageId': selectedPage['id'],
        'pageAccessToken': selectedPage['access_token'],
        'connectedAt': DateTime.now().toIso8601String(),
        'profilePic': '',
        'isRealConnection': true,
      };
      await prefs.setString(_facebookKey, json.encode(connectionData));
      return true;
    } catch (e) {
      debugPrint('Error connecting Facebook (real): $e');
      return false;
    }
  }

  // Mock Facebook OAuth connection (existing implementation)
  Future<bool> _connectFacebookMock(BuildContext context) async {
    // Show mock login dialog
    final credentials = await _showMockLoginDialog(context, 'Facebook');
    if (credentials == null) return false;

    // Show mock page selection
    final pageName = await _showPageSelectionDialog(context);
    if (pageName == null) return false;

    // Store connection data
    final prefs = await SharedPreferences.getInstance();
    final connectionData = {
      'username': credentials['username'],
      'pageName': pageName,
      'connectedAt': DateTime.now().toIso8601String(),
      'profilePic': 'https://via.placeholder.com/100', // Mock profile pic
      'isRealConnection': false,
    };
    await prefs.setString(_facebookKey, json.encode(connectionData));
    return true;
  }

  // Disconnect a platform
  Future<void> disconnectSocial(String platform) async {
    final prefs = await SharedPreferences.getInstance();
    if (platform.toLowerCase() == 'instagram') {
      await prefs.remove(_instagramKey);
    } else if (platform.toLowerCase() == 'facebook') {
      await prefs.remove(_facebookKey);
    }
  }

  // Get list of connected platforms
  Future<List<String>> getConnectedPlatforms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> connected = [];

    if (prefs.containsKey(_instagramKey)) {
      connected.add('Instagram');
    }
    if (prefs.containsKey(_facebookKey)) {
      connected.add('Facebook');
    }

    return connected;
  }

  // Check if user has any connection
  Future<bool> hasAnyConnection() async {
    final connected = await getConnectedPlatforms();
    return connected.isNotEmpty;
  }

  // Get account info for a platform
  Future<Map<String, dynamic>?> getAccountInfo(String platform) async {
    final prefs = await SharedPreferences.getInstance();
    String? data;

    if (platform.toLowerCase() == 'instagram') {
      data = prefs.getString(_instagramKey);
    } else if (platform.toLowerCase() == 'facebook') {
      data = prefs.getString(_facebookKey);
    }

    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  // Mock login dialog
  Future<Map<String, String>?> _showMockLoginDialog(
    BuildContext context,
    String platform,
  ) async {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login to $platform'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'username': usernameController.text,
                  'password': passwordController.text,
                });
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  // Account type selection dialog
  Future<String?> _showAccountTypeDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Account Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What type of Instagram account do you have?'),
            SizedBox(height: 16),
            _buildAccountTypeOption(context, 'Business'),
            _buildAccountTypeOption(context, 'Creator'),
            _buildAccountTypeOption(context, 'Personal'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeOption(BuildContext context, String type) {
    return ListTile(
      title: Text(type),
      leading: Radio<String>(
        value: type,
        groupValue: null,
        onChanged: (value) => Navigator.pop(context, value),
      ),
      onTap: () => Navigator.pop(context, type),
    );
  }

  // Personal account warning dialog
  Future<void> _showPersonalAccountWarning(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Account Type Not Supported'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Only Business and Creator accounts can post through this app.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('To convert your account:'),
            SizedBox(height: 8),
            Text('1. Go to Instagram Settings'),
            Text('2. Tap "Account"'),
            Text('3. Tap "Switch to Professional Account"'),
            Text('4. Choose Business or Creator'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  // Page selection dialog for Facebook (mock)
  Future<String?> _showPageSelectionDialog(BuildContext context) async {
    final List<String> mockPages = [
      'My Business Page',
      'Company Portfolio',
      'Professional Services',
    ];

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: mockPages
              .map(
                (page) => ListTile(
                  title: Text(page),
                  leading: Icon(Icons.pages),
                  onTap: () => Navigator.pop(context, page),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Real page selection dialog - shows actual Facebook Pages from API
  Future<Map<String, dynamic>?> _showRealPageSelectionDialog(
    BuildContext context,
    List<Map<String, dynamic>> pages,
  ) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Facebook Page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: pages
              .map(
                (page) => ListTile(
                  title: Text(page['name'] ?? 'Unknown Page'),
                  subtitle: Text('ID: ${page['id']}'),
                  leading: Icon(Icons.pages),
                  onTap: () => Navigator.pop(context, page),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
