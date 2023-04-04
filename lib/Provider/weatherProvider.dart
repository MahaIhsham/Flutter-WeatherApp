import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weatherapp/Model/DataModel.dart';
import 'package:intl/src/intl/date_format.dart';
import '../Database/db_handler.dart';
import '../Model/WeatherModel.dart';


class WeatherProvider extends ChangeNotifier{
  String imagedescription= 'clear';
  weatherModel? _weather;
  String Image='clear';
  String? Address;
  String? city;
  weatherModel? get weather => _weather;
  DBHelper? dbHelper=DBHelper.instance;
  bool? ActiveConnection ;
  String? Connection;
  List<DataModel>? weatherList=[];
  DataModel? weatherLastEntry;
 // bool hasInternet= false;
 //  Connectivity connectivity = Connectivity();
 //  bool hasConnection = false;
 //  ConnectivityResult? connectionMedium;
  StreamController<bool> connectionChangeController =
   StreamController.broadcast();
  Stream<bool> get connectionChange => connectionChangeController.stream;

  String date(){
    var today = DateTime.now();
    var dateFormat = DateFormat('dd-MM-yyyy');
    String currentDate = dateFormat.format(today);
    return currentDate;
  }
String  datetime = DateTime.now().toIso8601String();

  void showToast(String msg) {
    Fluttertoast.showToast(msg:msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // Future CheckUserConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       ActiveConnection = true;
  //       return showToast("Internet is Connected ");
  //     }
  //   // } on SocketException catch (_) {
  //   //   ActiveConnection = false;
  //   //   return showToast("Internet is not Connected ");
  //   // }
  // }
 //  void initalise() async{
 //    ConnectivityResult result = await Connectivity().checkConnectivity();
 // if(result==ConnectivityResult.mobile){
 //  return getWeather(city);
 // }
 // else {
 //
 // }
 //  }


  Future<String?> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Positiohghn: $position");
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.subAdministrativeArea}';
    print(Address);
    return  Address;
  }
  // ConnectivityService() {
  //   getWeather( city);
  // }


  Future<void>getWeather(String? city, ) async {
    dbHelper!.userinput==city;
    try {
      final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
        Connection="On";
        var url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b91c52c72dab65ce3bbef0880f342c97";
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          print("here in status code 200");
          var resBody = res.body;
          final jsonData = json.decode(resBody);
          _weather = weatherModel.fromJson(jsonData);
          // DataModel datamodel = jsonData.map((number)=>number.DataModel());
          dbHelper?.insert(DataModel(name: _weather!.name!,
              temperature: _weather!.main!.temp!,
              speed: _weather!.wind!.speed!,
              pressure: _weather!.main!.pressure!,
              icon: _weather!.weather![0].icon!,
              main: _weather!.weather![0].main!,
              feels: _weather!.main!.feelsLike!,
              humidity: _weather!.main!.humidity!, datetime:DateTime.now().toString() ,));
          weatherList = await dbHelper!.getWeatherList();
          weatherLastEntry = weatherList!.last;
          print("weatherList$weatherLastEntry");

          print(dbHelper);
          notifyListeners();
        }
        else if(res.statusCode !=200){
          showToast('Request Failed Because location is wrong');

          print('Request Failed Because location is wrong${res.statusCode}');
        }
        notifyListeners();
      }

          }
    on SocketException catch (_) {
        ActiveConnection = false;
        Connection="Off";
        weatherList = await dbHelper!.getWeatherList();
        weatherLastEntry = weatherList!.last;
        print("weatherList$weatherLastEntry");
        notifyListeners();



      }
  }


}

