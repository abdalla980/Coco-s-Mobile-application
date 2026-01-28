import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocos_mobile_application/core/services/location_service.dart';
import 'package:cocos_mobile_application/core/services/ai_caption_service.dart';
import 'package:cocos_mobile_application/core/services/social_connection_service.dart';
import 'package:cocos_mobile_application/config/env_config.dart';
import 'package:cocos_mobile_application/core/services/instagram_api_service.dart';
import 'package:cocos_mobile_application/core/services/facebook_api_service.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';

class PostPreviewPage extends StatefulWidget {
  final File imageFile;

  const PostPreviewPage({super.key, required this.imageFile});

  @override
  State<PostPreviewPage> createState() => _PostPreviewPageState();
}

class _PostPreviewPageState extends State<PostPreviewPage> {
  final LocationService _locationService = LocationService();
  final AICaptionService _aiService = AICaptionService();
  final SocialConnectionService _socialService = SocialConnectionService();
  final AuthService _authService = AuthService();

  TextEditingController? _captionController;
  String? _location;
  DateTime _generationTime = DateTime.now();
  bool _isInitialized = false;
  bool _isGeneratingCaption = false;

  // Platform selection
  bool _instagramSelected = false;
  bool _facebookSelected = false;
  bool _webSelected = false;

  @override
  void initState() {
    super.initState();
    _initializePost();
  }

  Future<void> _initializePost() async {
    // Get location
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      _location = await _locationService.getLocationString(position);
    }

    // Generate initial caption with AI
    await _generateCaption();

    // Auto-select connected platforms
    final connectedPlatforms = await _socialService.getConnectedPlatforms();
    setState(() {
      _instagramSelected = connectedPlatforms.contains('Instagram');
      _facebookSelected = connectedPlatforms.contains('Facebook');
      _webSelected = false; // Mock platform
      _isInitialized = true;
    });
  }

  Future<void> _generateCaption() async {
    setState(() => _isGeneratingCaption = true);

    try {
      // Fetch user profile for personalization from Firestore
      Map<String, dynamic>? userProfile;
      final user = _authService.currentUser;
      if (user != null) {
        final userDoc = await _authService.firestore
            .collection('users')
            .doc(user.uid)
            .get();
        userProfile = userDoc.data();

        // DEBUG: Print user profile to see what data we have
        debugPrint('🔍 User Profile Data: $userProfile');
        debugPrint(
          '📝 Onboarding Answers: ${userProfile?['onboardingAnswers']}',
        );
      }

      // Extract onboarding answers if they exist
      final onboardingAnswers =
          userProfile?['onboardingAnswers'] as Map<String, dynamic>?;

      // Generate caption from image with user context
      final caption = await _aiService.generateCaptionFromImage(
        widget.imageFile,
        location: _location,
        userProfile:
            onboardingAnswers, // Pass onboarding answers, not full user profile
      );

      if (_captionController == null) {
        _captionController = TextEditingController(text: caption);
      } else {
        _captionController!.text = caption;
      }

      setState(() => _generationTime = DateTime.now());
    } catch (e) {
      debugPrint('Error generating caption: $e');
      // Fallback to simple caption on error
      if (_captionController == null) {
        _captionController = TextEditingController(
          text: 'Check out this work! 💪\n\n#QualityWork #Professional',
        );
      }
    } finally {
      setState(() => _isGeneratingCaption = false);
    }
  }

  void _regenerateCaption() async {
    if (_captionController == null) return;
    await _generateCaption();
  }

  Future<void> _postNow() async {
    if (!_instagramSelected && !_facebookSelected && !_webSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one platform'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Posting...', style: GoogleFonts.poppins()),
            ],
          ),
        ),
      ),
    );

    // Post to selected platforms
    final List<String> successPosts = [];
    final List<String> failedPosts = [];

    // Post to Instagram if selected
    if (_instagramSelected) {
      final result = await _postToInstagram();
      if (result != null) {
        successPosts.add(result);
      } else {
        failedPosts.add('Instagram');
      }
    }

    // Post to Facebook if selected
    if (_facebookSelected) {
      final result = await _postToFacebook();
      if (result != null) {
        successPosts.add(result);
      } else {
        failedPosts.add('Facebook');
      }
    }

    // Post to Web (mock only)
    if (_webSelected) {
      await Future.delayed(Duration(seconds: 1));
      successPosts.add(
        '✓ Web: Post #WEB${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    Navigator.pop(context); // Close loading dialog

    // Show result dialog
    if (successPosts.isNotEmpty) {
      _showResultDialog(successPosts, failedPosts);
    } else {
      _showErrorDialog('Failed to post to all platforms');
    }
  }

  // Post to Instagram - uses real API if enabled
  Future<String?> _postToInstagram() async {
    if (EnvConfig.enableRealInstagram) {
      return await _postToInstagramReal();
    } else {
      return await _postToInstagramMock();
    }
  }

  // Real Instagram posting
  Future<String?> _postToInstagramReal() async {
    try {
      // Get Instagram connection data
      final accountInfo = await _socialService.getAccountInfo('instagram');
      if (accountInfo == null) return null;

      final accessToken = accountInfo['accessToken'] as String?;
      if (accessToken == null) {
        debugPrint('No access token found for Instagram');
        return null;
      }

      // NOTE: Real Instagram API requires images to be hosted on a public URL
      // For now, return an error message to remind user to implement image hosting
      _showErrorDialog(
        'Image hosting not implemented yet.\n\n'
        'Instagram requires images to be hosted on a public URL.\n'
        'Please add Firebase Storage or similar service to upload images first.',
      );
      return null;

      // TODO: When image hosting is implemented, use this code:
      // final igService = InstagramApiService();
      // final postId = await igService.postPhoto(
      //   igUserId: 'YOUR_IG_USER_ID', // Get from accountInfo or API
      //   imageUrl: 'PUBLIC_URL_TO_IMAGE',
      //   caption: _captionController?.text ?? '',
      //   accessToken: accessToken,
      // );
      // return postId != null ? '✓ Instagram: Post #$postId' : null;
    } catch (e) {
      debugPrint('Error posting to Instagram (real): $e');
      return null;
    }
  }

  // Mock Instagram posting
  Future<String?> _postToInstagramMock() async {
    await Future.delayed(Duration(seconds: 1));
    return '✓ Instagram: Post #IG${DateTime.now().millisecondsSinceEpoch}';
  }

  // Post to Facebook - uses real API if enabled
  Future<String?> _postToFacebook() async {
    if (EnvConfig.enableRealFacebook) {
      return await _postToFacebookReal();
    } else {
      return await _postToFacebookMock();
    }
  }

  // Real Facebook posting
  Future<String?> _postToFacebookReal() async {
    try {
      // Get Facebook connection data
      final accountInfo = await _socialService.getAccountInfo('facebook');
      if (accountInfo == null) return null;

      final pageId = accountInfo['pageId'] as String?;
      final pageAccessToken = accountInfo['pageAccessToken'] as String?;

      if (pageId == null || pageAccessToken == null) {
        debugPrint('No page ID or access token found for Facebook');
        return null;
      }

      // NOTE: Real Facebook API also requires images to be hosted on a public URL
      _showErrorDialog(
        'Image hosting not implemented yet.\n\n'
        'Facebook requires images to be hosted on a public URL.\n'
        'Please add Firebase Storage or similar service to upload images first.',
      );
      return null;

      // TODO: When image hosting is implemented, use this code:
      // final fbService = FacebookApiService();
      // final postId = await fbService.postPhoto(
      //   pageId: pageId,
      //   imageUrl: 'PUBLIC_URL_TO_IMAGE',
      //   message: _captionController?.text ?? '',
      //   pageAccessToken: pageAccessToken,
      // );
      // return postId != null ? '✓ Facebook: Post #$postId' : null;
    } catch (e) {
      debugPrint('Error posting to Facebook (real): $e');
      return null;
    }
  }

  // Mock Facebook posting
  Future<String?> _postToFacebookMock() async {
    await Future.delayed(Duration(seconds: 1));
    return '✓ Facebook: Post #FB${DateTime.now().millisecondsSinceEpoch}';
  }

  // Show success/partial success dialog
  void _showResultDialog(List<String> successPosts, List<String> failedPosts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              failedPosts.isEmpty ? Icons.check_circle : Icons.warning,
              color: failedPosts.isEmpty ? Colors.green : Colors.orange,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              failedPosts.isEmpty ? 'Posted Successfully!' : 'Partially Posted',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...successPosts.map((post) => Text(post)),
            if (failedPosts.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Failed: ${failedPosts.join(", ")}',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to dashboard
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    // Close loading dialog if open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Error', style: GoogleFonts.poppins()),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _captionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C3E50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Step 2/3',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.file(widget.imageFile, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '[ CAPTURED IMAGE ]',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_location != null)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _location!,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Caption and options section
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _isInitialized
                  ? SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // COCO Assistant header
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: Colors.green.shade700,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'COCO Assistant',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Caption generated in ${(DateTime.now().difference(_generationTime).inMilliseconds / 1000).toStringAsFixed(1)}s',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _regenerateCaption,
                                icon: Icon(Icons.refresh, size: 18),
                                label: Text('Regenerate'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Caption text field
                          TextField(
                            controller: _captionController!,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: 'Write a caption...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          SizedBox(height: 24),

                          // Publishing to section
                          Text(
                            'PUBLISHING TO',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),

                          // Platform selection
                          Row(
                            children: [
                              Expanded(
                                child: _buildPlatformCheckbox(
                                  'Instagram',
                                  _instagramSelected,
                                  (value) => setState(
                                    () => _instagramSelected = value!,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: _buildPlatformCheckbox(
                                  'Facebook',
                                  _facebookSelected,
                                  (value) => setState(
                                    () => _facebookSelected = value!,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: _buildPlatformCheckbox(
                                  'Web',
                                  _webSelected,
                                  (value) =>
                                      setState(() => _webSelected = value!),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),

                          // Post Now button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _postNow,
                              icon: Icon(Icons.share, size: 24),
                              label: Text(
                                'Post Now',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCheckbox(
    String platform,
    bool selected,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: selected,
            onChanged: onChanged,
            activeColor: Colors.green,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: 4),
          Text(
            platform,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? Colors.green.shade900 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
