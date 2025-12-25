import 'package:cocos_mobile_application/main.dart';
import 'package:cocos_mobile_application/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with SingleTickerProviderStateMixin {
  @override
void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_)=>const Welcomepage()));
    });
  }

  @override
void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
        body:  Center(
          child: Image.asset("images/cocoIcon.png", width: MediaQuery.of(context).size.width * 0.6),
        ),
    );
  }
}
