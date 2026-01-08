import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocos_mobile_application/social_connection_service.dart';

class ConnectSocialPage extends StatefulWidget {
  const ConnectSocialPage({super.key});

  @override
  State<ConnectSocialPage> createState() => _ConnectSocialPageState();
}

class _ConnectSocialPageState extends State<ConnectSocialPage> {
  final SocialConnectionService _socialService = SocialConnectionService();
  Map<String, dynamic>? _instagramInfo;
  Map<String, dynamic>? _facebookInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    setState(() => _loading = true);
    _instagramInfo = await _socialService.getAccountInfo('instagram');
    _facebookInfo = await _socialService.getAccountInfo('facebook');
    setState(() => _loading = false);
  }

  Future<void> _connectInstagram() async {
    final success = await _socialService.connectInstagram(context);
    if (success) {
      _loadConnections();
      _showSuccessSnackbar('Instagram connected successfully!');
    }
  }

  Future<void> _connectFacebook() async {
    final success = await _socialService.connectFacebook(context);
    if (success) {
      _loadConnections();
      _showSuccessSnackbar('Facebook connected successfully!');
    }
  }

  Future<void> _disconnect(String platform) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disconnect $platform?'),
        content: Text(
          'Are you sure you want to disconnect your $platform account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _socialService.disconnectSocial(platform);
      _loadConnections();
      _showSuccessSnackbar('$platform disconnected');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Connect Social Media',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link your social media accounts to post your work',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildSocialCard(
                    platform: 'Instagram',
                    icon: Icons.camera_alt,
                    iconColor: Color(0xFFE4405F),
                    accountInfo: _instagramInfo,
                    onConnect: _connectInstagram,
                    onDisconnect: () => _disconnect('Instagram'),
                  ),
                  SizedBox(height: 16),
                  _buildSocialCard(
                    platform: 'Facebook',
                    icon: Icons.facebook,
                    iconColor: Color(0xFF1877F2),
                    accountInfo: _facebookInfo,
                    onConnect: _connectFacebook,
                    onDisconnect: () => _disconnect('Facebook'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSocialCard({
    required String platform,
    required IconData icon,
    required Color iconColor,
    required Map<String, dynamic>? accountInfo,
    required VoidCallback onConnect,
    required VoidCallback onDisconnect,
  }) {
    final isConnected = accountInfo != null;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected ? Colors.green.shade200 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isConnected) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Connected',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isConnected)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: onDisconnect,
                )
              else
                ElevatedButton(
                  onPressed: onConnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Connect'),
                ),
            ],
          ),
          if (isConnected) ...[
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.grey.shade600),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountInfo['username'] ?? 'User',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (accountInfo['accountType'] != null)
                        Text(
                          '${accountInfo['accountType']} Account',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      if (accountInfo['pageName'] != null)
                        Text(
                          accountInfo['pageName'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
