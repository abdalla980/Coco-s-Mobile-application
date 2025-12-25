import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Good morning,\nFlorian", style: GoogleFonts.poppins(fontSize: 20)),

                const Spacer(),

                Image.asset("images/pajamas_profile.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("images/Vector.png"),
                )
              ],
            ),
            const SizedBox(height: 44),
Container(
  padding: EdgeInsets.all(20),
  width: 500,
  height: 150,
  decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black, width:0.5)
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
children: [
    Text("Weekly Reach",
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    Row(
      children: [
        Text("2,405",
          style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("+12%",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.green),
          ),
        ),
      ],
    ),
  const Spacer(),

  Text("Views across Google & Instagram",
      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500),
    ),
],
  ),
),
            const SizedBox(height: 42),

            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.green,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   Image.asset("images/Camera-icon.png"),
                          Text("Capture Work", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Create New Post", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w300))

                    ]
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(42.0),
              child:
              Text("Tap the button to snap a photo of your latest installation", style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400),),
            )

          ],
        ),
        ),
    );
  }
}
