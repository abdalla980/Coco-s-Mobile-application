import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocos_mobile_application/core/services/social_connection_service.dart';
import 'package:cocos_mobile_application/features/social/connect_social_page.dart';
import 'package:cocos_mobile_application/features/dashboard/home_screen.dart';

class WeeklyReachPage extends StatelessWidget {
  const WeeklyReachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: SafeArea(
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Weekly Reach",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: FutureBuilder<bool>(
        future: _checkSocialConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == false) {
            // No social connection, redirect after a moment
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectSocialPage(),
                ),
              );
            });
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Likes",
                        "805",
                        Icons.favorite,
                        Colors.pink,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Views",
                        "3,923",
                        Icons.visibility,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Saves",
                        "634",
                        Icons.bookmark,
                        Colors.pink.shade300,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Reposts",
                        "147",
                        Icons.repeat,
                        Colors.purple.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Line Graph
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weekly Performance",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(height: 200, child: _buildLineGraph()),
                      const SizedBox(height: 16),
                      _buildDateLabels(),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Views Breakdown Circle
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Views Breakdown",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: _buildViewsCircle(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem("Followers", Colors.pink),
                          const SizedBox(width: 32),
                          _buildLegendItem("Non-Followers", Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Additional Stats Section
                Text(
                  "Performance Metrics",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Posts Generated",
                        "12",
                        Icons.photo_camera,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Followers Gained",
                        "+234",
                        Icons.person_add,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Engagement Rate",
                        "4.2%",
                        Icons.trending_up,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Reach",
                        "8.5K",
                        Icons.people,
                        Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Capture More Work Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Homescreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.green.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          "Capture More Work",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _checkSocialConnection() async {
    final socialService = SocialConnectionService();
    return await socialService.hasAnyConnection();
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineGraph() {
    // Demo data points
    final dataPoints = [40.0, 55.0, 45.0, 70.0, 65.0, 80.0, 75.0];
    final maxValue = 100.0;

    return CustomPaint(
      painter: LineGraphPainter(dataPoints, maxValue),
      child: Container(),
    );
  }

  Widget _buildDateLabels() {
    // Generate dates for the last 7 days
    final now = DateTime.now();
    final dates = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return date;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dates.map((date) {
        final dayName = _getDayName(date.weekday);
        final dayNumber = date.day;
        return Column(
          children: [
            Text(
              dayName,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNumber.toString(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  Widget _buildViewsCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(painter: ViewsCirclePainter()),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "3,923",
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Total Views",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

class LineGraphPainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxValue;

  LineGraphPainter(this.dataPoints, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw line graph
    final pointDistance = size.width / (dataPoints.length - 1);
    final path = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final x = pointDistance * i;
      final y = size.height - (dataPoints[i] / maxValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw point
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ViewsCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw follower section (60% - pink)
    final followerPaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.14159 / 180,
      216 * 3.14159 / 180,
      true,
      followerPaint,
    );

    // Draw non-follower section (40% - purple)
    final nonFollowerPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (126) * 3.14159 / 180,
      144 * 3.14159 / 180,
      true,
      nonFollowerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
