import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

/// Temporary utility to get Android Key Hash for Facebook
/// Run this once, copy the hash, then remove this file
void main() {
  runApp(KeyHashApp());
}

class KeyHashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Key Hash Generator')),
        body: KeyHashWidget(),
      ),
    );
  }
}

class KeyHashWidget extends StatefulWidget {
  @override
  _KeyHashWidgetState createState() => _KeyHashWidgetState();
}

class _KeyHashWidgetState extends State<KeyHashWidget> {
  String keyHash = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _generateKeyHash();
  }

  Future<void> _generateKeyHash() async {
    try {
      // Get debug keystore path
      final home =
          Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
      final keystorePath = '$home\\.android\\debug.keystore';

      setState(() {
        keyHash =
            'Debug Keystore Path:\\n$keystorePath\\n\\n'
            'To generate key hash, run this command in terminal:\\n\\n'
            'keytool -exportcert -alias androiddebugkey '
            '-keystore \"$keystorePath\" '
            '-storepass android -keypass android | '
            'openssl sha1 -binary | openssl base64\\n\\n'
            'OR\\n\\n'
            'Use flutter_facebook_auth package to get it at runtime.';
      });
    } catch (e) {
      setState(() {
        keyHash = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Android Key Hash for Facebook SDK',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                keyHash,
                style: TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
