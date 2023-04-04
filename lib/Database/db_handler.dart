
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weatherapp/Model/DataModel.dart';

import '../Model/WeatherModel.dart';
class DBHelper{
  static Database? dbase;
  String? userinput;
  Future<Database?> get db async {
    if (dbase != null) {
      return dbase;
    }
    dbase = await initDatabase();
    return dbase;
  }
  DBHelper._privateConstructor();
  static final instance = DBHelper._privateConstructor();
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'weather.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, );
    return db;
  }
  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE weather(id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,name STRING NOT NULL, temperature Double NOT NULL,humidity INTEGER NOT NULL, speed TEXT NOT NULL,pressure INTEGER NOT NULL,icon STRING NOT NULL,main STRING NOT NULL, feels DOUBLE NOT NULL, datetime STRING NOT NULL)");

  }

  Future<DataModel> insert(DataModel dataModel) async {
    var dbClient = await db;
    await dbClient!.insert('weather', dataModel.toMap());
    return dataModel;
  }
  Future<List<DataModel>> getWeatherList() async {
    var dbClient = await db;
    print("queryResult ");
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('weather');
    print("queryResult $queryResult");
    return queryResult.map((e) => DataModel.fromMap(e)).toList();
  }
  Future<List<DataModel>> getUserInput(String userInput) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryInput =
    await dbClient!.query('weather', where: 'name = ?', whereArgs: [userInput]);
    List<DataModel> data =  queryInput.map((e) => DataModel.fromMap(e)).toList();
    return data;
  }


}