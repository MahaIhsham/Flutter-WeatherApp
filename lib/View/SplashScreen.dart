import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapp/View/WeatherApp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
               WeatherApp()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
 Center(child: Container(
   width: MediaQuery.of(context).size.width*0.5,
   height: MediaQuery.of(context).size.height*0.25 ,
   decoration:  BoxDecoration(

       image: DecorationImage(image:AssetImage('images/icon.png'),
         fit: BoxFit.cover,

       ),
     borderRadius: BorderRadius.circular(20),
   ),
    ),
 ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01, ),
            Center(child: Text("Weather APP",style:TextStyle(decoration: TextDecoration.none,fontSize: MediaQuery.of(context).size.height*0.05,color: Colors.blue.shade600,fontWeight: FontWeight.w600) ,)),
          ],
        )
    );
  }

}
