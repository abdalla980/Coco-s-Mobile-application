import 'package:cocos_mobile_application/Questions/Question2.dart';
import 'package:cocos_mobile_application/WebsiteMaker/WebsiteRequested.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class webQuestion3 extends StatelessWidget {
  const webQuestion3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              const SizedBox(height: 24),
              Container(
                margin: EdgeInsets.only(right: 8, top: 32) ,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.green,
                        width:2
                    )
                ),
                child:
                Text("3.Whats your budget for the website?",
                    style: GoogleFonts.poppins(fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    )
                ),
              ),
              const SizedBox(height: 150),

              TextField(
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: Colors.green,
                            width:2)
                    ),

                  )
              ),
              Spacer(),

              SizedBox(
                  width: 300,
                  height: 50,
                  child:
                  FloatingActionButton.extended(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Websiterequested())
                    );
                  },
                    label: Text("Submit",
                        style: GoogleFonts.poppins(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )),
                    backgroundColor: Colors.green,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    extendedPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  )

              ),                ],
          ),
        )
    );
  }
}
