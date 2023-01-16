class Forecast {
  Forecast({
    required this.dt,
    required this.temp,
    required this.pressure,
    required this.humidity,
    required this.weather,
  });
  late final int dt;
  late final Temp temp;
  late final int pressure;
  late final int humidity;
  late final List<Weather> weather;

  Forecast.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    temp = Temp.fromJson(json['temp']);
    pressure = json['pressure'];
    humidity = json['humidity'];
    weather =
        List.from(json['weather']).map((e) => Weather.fromJson(e)).toList();
  }
}

class Temp {
  late final num day;
  late final num min;
  late final num max;
  Temp({required this.day, required this.min, required this.max});

  Temp.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    min = json['min'] - 273;
    max = json['max'] - 273;
  }
}

class Weather {
  Weather({
    required this.main,
    required this.icon,
  });
  late final String main;
  late final String icon;

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'] ?? '';
    icon = json['icon'] ?? '';
  }
}
