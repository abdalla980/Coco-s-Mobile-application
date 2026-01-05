import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SocialConnectionService {
  // Keys for SharedPreferences
  static const String _instagramKey = 'instagram_connection';
  static const String _facebookKey = 'facebook_connection';

  // Mock OAuth: Connect Instagram with account type verification
  Future<bool> connectInstagram(BuildContext context) async {
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
    };
    await prefs.setString(_instagramKey, json.encode(connectionData));
    return true;
  }

  // Mock OAuth: Connect Facebook with page selection
  Future<bool> connectFacebook(BuildContext context) async {
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

  // Page selection dialog for Facebook
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
}
