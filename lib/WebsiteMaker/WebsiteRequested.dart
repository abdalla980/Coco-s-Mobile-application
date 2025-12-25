import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Websiterequested extends StatelessWidget {
  const Websiterequested({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Website Requested", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),)),
    );
  }
}
