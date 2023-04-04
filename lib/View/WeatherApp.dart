

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/Database/db_handler.dart';
import 'package:weatherapp/Model/DataModel.dart';
import 'package:weatherapp/Model/WeatherModel.dart';
import 'package:weatherapp/Provider/weatherProvider.dart';
import 'package:intl/intl.dart';
class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String Address = 'search';
  TextEditingController controller =TextEditingController();
  weatherModel? weatherofcities;
  String Image1='clear';
  bool? ActiveConnection;
  DateTime datetime = DateTime.now();
  DBHelper dbHelper= DBHelper.instance;
  String? msg;
  bool off= false;
  String? city;
  ConnectivityResult? result;
  late StreamSubscription SUBSCRIPTION;
  final _connectivity = Connectivity();
  Map _source = {ConnectivityResult.none: false};
 
 String time(){
   var today = DateTime.now();
   var dateFormat = DateFormat('dd-MM-yyyy');
   String currentDate = dateFormat.format(today);
   return currentDate;
 }
  @override
  void initState()  {
    // TODO: implement initState
    WeatherProvider weatherProvider1= Provider.of<WeatherProvider>(context,listen: false);
    // ConnectivityResult result = await _connectivity.checkConnectivity();
    // weatherprovider.getLocation().then((value) => _getWeather(context, value!,));
    SUBSCRIPTION= Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      if(result == ConnectivityResult.wifi){
        weatherProvider1.ActiveConnection = true;
        print("ActiveConnection:$ActiveConnection");
         weatherProvider1.getLocation().then((value) => _getWeather(context, value!,));

      }
      else if(result==ConnectivityResult.mobile){
        weatherProvider1.ActiveConnection = true;
        weatherProvider1.getLocation().then((value) => _getWeather(context, value!,));
      }
      else{
        weatherProvider1.ActiveConnection = false;
        print("ActiveConnection here in weather screen:${weatherProvider1.ActiveConnection}");
        weatherProvider1.getLocation().then((value) => _getWeather(context, value!,));
      }

    });
    super.initState();
  }
  void _getWeather(BuildContext context, String input) async{

    WeatherProvider weatherprovider= Provider.of<WeatherProvider>(context,listen: false);
    weatherprovider.getWeather(input);

  }

  @override
  Widget build(BuildContext context) {
    // String string;
    // switch (_source.keys.toList()[0]) {
    //   case ConnectivityResult.mobile:
    //     string = 'Mobile: Online';
    //     break;
    //   case ConnectivityResult.wifi:
    //     string = 'WiFi: Online';
    //     break;
    //   case ConnectivityResult.none:
    //   default:
    //     string = 'Offline';
    // }
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height: height*1,
              width: width*1,
              child:
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        'images/lightcloud.png'),
                      fit: BoxFit.cover,
                    )
                ),
                child:
              Consumer<WeatherProvider>(builder: (context , weatherprovider, child){

                 if (weatherprovider.weatherLastEntry== null) {
                   return Container(
                     decoration: const BoxDecoration(
                         image: DecorationImage(
                           image: AssetImage("images/clear.jpg"),
                           fit: BoxFit.cover,
                         )
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         const CircularProgressIndicator(),
                         Padding(
                           padding: EdgeInsets.all(width * 0.15),
                           child: Text('Please wait while fetching data ',
                             style: TextStyle(
                                 color: Colors.white, fontSize: height * .03),),
                         ),
                       ],
                     ),
                   );
                 }
                 else {
                   DateTime  updateinformation= DateTime.parse(weatherprovider.weatherLastEntry!.datetime);
                   return Container(
                     decoration: const BoxDecoration(
                         image: DecorationImage(image: AssetImage(
                             'images/clear.jpg'),
                           fit: BoxFit.cover,
                         )
                     ),
                     child: Column(
                       children: [
                         weatherprovider.ActiveConnection != off?
                         AppBar(
                           backgroundColor: Colors.lightBlue.shade600,
                           title:
                           Container(
                             height: 35,
                             decoration: BoxDecoration(
                                 color: Colors.white, borderRadius: BorderRadius.circular(5)),
                             child: Center(
                               child: TextField(
                                 onSubmitted: (String input) {
                                   _getWeather(context, input);
                                 },
                                 controller: controller,
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: height * 0.03,
                                 ),
                                 decoration: InputDecoration(
                                     hintText: ' Search  loctaion...',
                                     border:InputBorder.none,
                                     hintStyle: TextStyle(
                                       color: Colors.black,
                                       fontSize: height * 0.025,
                                     ),
                                     prefixIcon: const Icon(
                                       Icons.search, color: Colors.black,)
                                 ),
                               ),
                             ),
                           ),

                         )
                             : AppBar(title:Text("WeatherApp", style: TextStyle(
                             color: Colors.white,
                             fontSize: height * .035,fontWeight: FontWeight.w600),),),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(height: height * 0.03,),
                             Row(
                               children: [
                                 Padding(
                                   padding:  EdgeInsets.only(left: height*0.25),
                                   child: Text("Internet Connection", style: TextStyle(color: Colors.white,fontSize: height*0.025,fontWeight: FontWeight.w600),),
                                 ),
                                 Text(" ${weatherprovider.Connection}",style: TextStyle(color: weatherprovider.ActiveConnection!=off? Colors.green.shade900: Colors.red,fontSize: height*0.025,fontWeight: FontWeight.w600))
                               ],
                             ),
                             SizedBox(height: height * 0.06,),
                             SizedBox(
                               height: height * 0.09,
                               width: width * 1,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Padding(
                                         padding: EdgeInsets.only(left: height * 0.04),
                                         child: Text("Current Weather", style: TextStyle(
                                             color: Colors.white,
                                             fontSize: height * .025),),
                                       ),
                                       Padding(
                                         padding: EdgeInsets.only(left: height * 0.04),
                                         child: Text(time(), style: TextStyle(
                                             color: Colors.white,
                                             fontSize: height * .025),),
                                       ),
                                     ],
                                   ),
                                   Padding(
                                     padding:  EdgeInsets.only(right: height*0.02),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.only(left: height * 0.04),
                                           child: Text("Last Updation", style: TextStyle(
                                               color: Colors.white,
                                               fontSize: height * .025),),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.only(left: height * 0.04),
                                           child: Text('${DateFormat('KK:mm a').format(updateinformation)}', style: TextStyle(
                                               color: Colors.white,
                                               fontSize: height * .025),),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.only(left: height * 0.04),
                                           child: Text("${DateFormat('dd-MM-yyyy').format(updateinformation)}",
                                               style: TextStyle(
                                               color: Colors.white,
                                               fontSize: height * .025),) ,
                                         ),

                                       ],
                                     ),
                                   ),

                                 ],
                               ),
                             ),
                             SizedBox(height: height * 0.03,),
                             SingleChildScrollView(
                               scrollDirection: Axis.horizontal,
                               child: Row(
                                 children: [
                                   Padding(
                                     padding: EdgeInsets.only(
                                         left: height * 0.035, top: height * 0.065),
                                     child: Text(
                                       '${weatherprovider.weatherLastEntry?.name}',
                                       style: TextStyle(color: Colors.white,
                                           fontSize: height * .07),
                                     ),
                                   ),

                                   Padding(
                                     padding: EdgeInsets.only(
                                         left: height * 0.065, top: height * 0.065),
                                     child: Column(
                                       children: [
                                         Padding(
                                           padding: EdgeInsets.only(
                                               left: width * 0.09),
                                           child: Row(
                                             children: [

                                               Text(

                                                 '${ weatherprovider.weatherLastEntry!.main} ',

                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontSize: height * .03),

                                               ),
                                               const Icon(Icons.cloud_queue,
                                                 color: Colors.white, size: 18,)
                                             ],
                                           ),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.only(
                                               left: width * 0.09),
                                           child: Text(

                                             'Feels like${ weatherprovider.weatherLastEntry!.feels} ',

                                             style: TextStyle(color: Colors.white,
                                                 fontSize: height * .02),

                                           ),
                                         ),
                                       ],
                                     ),
                                   ),

                                 ],
                               ),
                             ),

                             Row(
                               children: [
                  weatherprovider.ActiveConnection==true?           Image.network(
                                     "http://openweathermap.org/img/wn/${weatherprovider
                                         .weatherLastEntry!.icon}@2x.png"): Padding(
                                           padding:  EdgeInsets.all( height*0.03),
                                           child: const Icon(Icons.thermostat_auto,color: Colors.white,size: 30,),
                                         ),
                                 Padding(
                                   padding: EdgeInsets.only(left: width * 0),
                                   child: Center(

                                     child: Text(

                                       '${ ((weatherprovider.weatherLastEntry!.temperature-
                                           32) * 5 / 9).toStringAsFixed(0)} ℃',

                                       style: TextStyle(color: Colors.white,
                                           fontSize: height * .06),

                                     ),

                                   ),
                                 ),

                               ],
                             ),
                             SizedBox(height: height * 0.03,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 Column(
                                   children: [
                                     Row(
                                       children: [
                                         Center(
                                           child: Text(
                                             'Humidity',
                                             style: TextStyle(color: Colors.white,
                                                 fontSize: height * .025),
                                           ),
                                         ),
                                         SizedBox(width: width * 0.02,),
                                         Icon(
                                           Icons.error_outline, color: Colors.white,
                                           size: 16,),
                                       ],
                                     ),
                                     Center(
                                       child: Text(
                                         '${weatherprovider.weatherLastEntry!
                                             .humidity} %',
                                         style: TextStyle(color: Colors.white,
                                             fontSize: height * .025),
                                       ),
                                     ),
                                   ],
                                 ),
                                 SizedBox(width: width * 0.02,),
                                 Column(
                                   children: [
                                     Row(
                                       children: [
                                         Center(
                                           child: Text(
                                             'Speed',
                                             style: TextStyle(color: Colors.white,
                                                 fontSize: height * .025),
                                           ),
                                         ),
                                         SizedBox(width: width * 0.02,),
                                         Icon(
                                           Icons.error_outline, color: Colors.white,
                                           size: 16,),
                                       ],
                                     ),
                                     Center(
                                       child: Text(
                                         '${weatherprovider.weatherLastEntry!
                                             .speed} km/h',
                                         style: TextStyle(color: Colors.white,
                                             fontSize: height * .025),
                                       ),
                                     ),
                                   ],
                                 ),
                                 SizedBox(width: width * 0.02,),
                                 Column(
                                   children: [
                                     Row(
                                       children: [
                                         Center(
                                           child: Text(
                                             'Pressure',
                                             style: TextStyle(color: Colors.white,
                                                 fontSize: height * .025),
                                           ),
                                         ),
                                         SizedBox(width: width * 0.02,),
                                         Icon(
                                           Icons.error_outline, color: Colors.white,
                                           size: 16,),
                                       ],
                                     ),
                                     Center(
                                       child: Text(
                                         '${weatherprovider.weatherLastEntry!
                                             .pressure} mb',
                                         style: TextStyle(color: Colors.white,
                                             fontSize: height * .02),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),



                           ],
                         ),
                       ],
                     ),
                   );



                 }
               }





              ),

            ),
          ),
        )
      )
      ),
    );
  }

}

