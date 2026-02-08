import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocos_mobile_application/features/dashboard/home_screen.dart';

class PostSuccessScreen extends StatelessWidget {
  final File imageFile;
  final String caption;
  final String instagramHandle;
  final String location;

  const PostSuccessScreen({
    super.key,
    required this.imageFile,
    required this.caption,
    required this.instagramHandle,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.green, size: 60),
              ),
              const SizedBox(height: 24),

              // Success text
              Text(
                'Success!',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your post is live on Instagram.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 32),

              // Instagram post preview card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Instagram header
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Profile picture
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Username and location
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  instagramHandle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (location.isNotEmpty)
                                  Text(
                                    location,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // More options
                          Icon(Icons.more_vert, size: 20),
                        ],
                      ),
                    ),

                    // Posted image
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          color: Colors.grey.shade200,
                          child: Image.file(imageFile, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'POSTED',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Instagram action buttons
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 26),
                          const SizedBox(width: 16),
                          Icon(Icons.mode_comment_outlined, size: 26),
                          const SizedBox(width: 16),
                          Icon(Icons.send_outlined, size: 26),
                          Spacer(),
                          Icon(Icons.bookmark_border, size: 26),
                        ],
                      ),
                    ),

                    // Likes count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '2 likes',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Caption
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '$instagramHandle ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: caption.length > 80
                                  ? '${caption.substring(0, 80)}... '
                                  : '$caption ',
                            ),
                            if (caption.length > 80)
                              TextSpan(
                                text: 'more',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Back to Dashboard button
              TextButton.icon(
                onPressed: () {
                  // Navigate back to dashboard, removing all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Homescreen()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text(
                  'Back to Dashboard',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
