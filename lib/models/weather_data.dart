class WeatherData {
  late final List<Weather> weather;
  late final Main main;
  late final Wind wind;
  late final int timezone;
  late final String name;

  WeatherData(
      {required this.weather,
      required this.main,
      required this.wind,
      this.timezone = 0,
      this.name = ''});

  WeatherData.fromJson(Map<String, dynamic> json) {
    weather =
        List.from(json['weather']).map((e) => Weather.fromJson(e)).toList();
    main = Main.fromJson(json['main']);
    wind = Wind.fromJson(json['wind']);
    timezone = json['timezone'];
    name = json['name'];
  }
}

class Weather {
  late final String main;
  late final String description;
  late final String icon;

  Weather({this.main = '', this.description = '', this.icon = ''});

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'] ?? '';
    description = json['description'] ?? '';
    icon = json['icon'] ?? '';
  }
}

class Main {
  late final double temp;
  late final double feelsLike;
  late final double tempMin;
  late final double tempMax;
  late final int pressure;
  late final int humidity;

  Main({
    this.temp = 0,
    this.feelsLike = 0,
    this.tempMin = 0,
    this.tempMax = 0,
    this.pressure = 0,
    this.humidity = 0,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'] - 273;
    feelsLike = json['feels_like'] - 273;
    tempMin = json['temp_min'] - 273;
    tempMax = json['temp_max'] - 273;
    pressure = json['pressure'];
    humidity = json['humidity'];
  }
}

class Wind {
  late final double speed;
  late final int deg;
  Wind({this.speed = 0, this.deg = 0});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'] ?? 0;
    deg = json['deg'] ?? 0;
  }
}
