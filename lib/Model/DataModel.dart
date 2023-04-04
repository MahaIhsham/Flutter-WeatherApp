class DataModel{
  int? id;
 String name;
  double temperature;
  var speed;
  int pressure ;
  String icon;
  String main;
  double feels;
  int humidity;
  String datetime;

  DataModel({
    this.id ,
    required this.name,
    required this.temperature,
    required this.speed,
    required this.pressure,
    required this.icon,
    required this.main,
    required this.feels,
    required this.humidity,
    required this.datetime,

  });
  DataModel.fromMap(Map<String , dynamic> res) :
        id = res['id'],
        name=res['name'],
       temperature= res['temperature'],
        speed = res['speed'],
        pressure = res['pressure'],
        icon = res['icon'],
        main = res['main'],
        feels= res['feels'],
        humidity=res['humidity'],
        datetime=res['datetime'];



  Map<String , Object?> toMap(){
    return {
      'id' : id,
      'name' : name,
      'temperature' : temperature,
      'speed' : speed,
      'pressure' : pressure,
      'icon' : icon,
      'main': main,
      'feels': feels,
      'humidity': humidity,
      'datetime':datetime,

    };
  }
}