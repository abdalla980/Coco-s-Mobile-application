import 'package:cocos_mobile_application/features/dashboard/dashboard.dart';
import 'package:cocos_mobile_application/features/settings/settings.dart';
import 'package:cocos_mobile_application/features/website_maker/web_question_1.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int myIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    webQuestion1(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) => setState(() => myIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: "Request Website",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
