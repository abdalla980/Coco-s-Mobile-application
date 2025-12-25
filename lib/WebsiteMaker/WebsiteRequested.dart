import 'package:cocos_mobile_application/Dashboard.dart';
import 'package:cocos_mobile_application/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebsiteRequested extends StatefulWidget {
  const WebsiteRequested({super.key});

  @override
  State<WebsiteRequested> createState() => _WebsiteRequestedState();
}

class _WebsiteRequestedState extends State<WebsiteRequested> {
  int myIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return _buildWebsiteRequestedContent();
      case 2:
        return const Settings();
      default:
        return _buildWebsiteRequestedContent();
    }
  }

  Widget _buildWebsiteRequestedContent() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 60,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 48),

              Text(
                "Wait for our team to email you,",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.mark_email_read_outlined,
                      color: Colors.green.shade700,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Pay attention to your inbox!",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                child: Text(
                  "We'll have the website of your dreams ready ASAP.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _getPage(myIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) => setState(() => myIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.computer), label: "Website Builder"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
