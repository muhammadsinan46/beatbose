import 'dart:async';

import 'package:beatboseapp/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 5), ()=> 
    Navigator.pushReplacement(
      context, MaterialPageRoute(
      builder: (context)=>
       const HomePage()
      )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
            Center(
              child: SizedBox(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Stack(
                  children: [
        
                      SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset('assets/images/logo.png',fit:BoxFit.cover,),
                ),
                                       
                  ],
                ),
                  ],
                  
                ),
              ),
            ),
    );
    

}
}