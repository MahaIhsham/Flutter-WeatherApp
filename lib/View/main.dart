import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:weatherapp/Provider/weatherProvider.dart';
import 'package:weatherapp/View/SplashScreen.dart';

import 'WeatherApp.dart';


void main() {
  runApp(
      ChangeNotifierProvider(create: (_)=> WeatherProvider()  ,
      child: Home(),)
     );
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    // WeatherProvider weatherprovider= Provider.of<WeatherProvider>(context,listen: false);
    // weatherprovider.initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}



