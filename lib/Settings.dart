import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Settings", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),)),
      
    );
  }
}
